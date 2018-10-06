/*
 * Copyright (C) 2006-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/core/Equipment.h"
#include "solarus/core/Map.h"
#include "solarus/core/System.h"
#include "solarus/entities/Hero.h"
#include "solarus/entities/Jumper.h"
#include "solarus/entities/Stream.h"
#include "solarus/entities/StreamAction.h"
#include "solarus/hero/CustomState.h"
#include "solarus/hero/PushingState.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/movements/PlayerMovement.h"

namespace Solarus {

/**
 * \brief Constructor.
 * \param description Description of this state or an empty string.
 */
CustomState::CustomState(
    const std::string& description):
  HeroState("custom"),
  description(description),
  visible(true),
  draw_override(),
  can_control_direction(true),
  can_control_movement(true),
  player_movement(),
  touching_ground(true),
  ignored_grounds(),
  can_start_sword(true),
  can_use_shield(true),
  can_start_item(true),
  can_push(true),
  pushing_delay(1000),
  pushing_direction4(-1),
  start_pushing_date(0),
  can_pick_treasure(true),
  can_take_stairs(true),
  can_take_jumper(true),
  current_jumper(nullptr),
  jumper_start_date(0),
  jumper_delay(200),
  previous_carried_object_behavior(CarriedObject::Behavior::THROW),
  carried_object(nullptr) {

}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& CustomState::get_lua_type_name() const {
  return LuaContext::state_module_name;
}

/**
 * \copydoc Entity::State::start
 */
void CustomState::start(const State* previous_state) {

  HeroState::start(previous_state);

  if (get_can_control_movement()) {
    start_player_movement();
  }
  pushing_direction4 = -1;
  start_pushing_date = 0;
  current_jumper = nullptr;
  jumper_start_date = 0;

  if (get_previous_carried_object_behavior() == CarriedObject::Behavior::KEEP &&
      previous_state != nullptr) {
    // Keep the carried object of the previous state.
    carried_object = previous_state->get_carried_object();
    HeroSprites& sprites = get_sprites();
    sprites.set_lifted_item(carried_object);
  }

  std::string previous_state_name;
  const CustomState* previous_custom_state = nullptr;
  if (previous_state != nullptr) {
    previous_state_name = previous_state->get_name();
    if (previous_state_name == "custom") {
      previous_custom_state = static_cast<const CustomState*>(previous_state);
    }
  }
  get_lua_context().state_on_started(
        *this, previous_state_name, const_cast<CustomState*>(previous_custom_state));  // TODO
}

/**
 * \copydoc Entity::State::stop
 */
void CustomState::stop(const State* next_state) {

  HeroState::stop(next_state);

  if (get_can_control_movement()) {
    get_entity().clear_movement();
  }
  cancel_jumper();
  player_movement = nullptr;

  if (carried_object != nullptr) {

    switch (next_state->get_previous_carried_object_behavior()) {

    case CarriedObject::Behavior::THROW:
      carried_object->throw_item(get_sprites().get_animation_direction());
      get_entities().add_entity(carried_object);
      get_sprites().set_lifted_item(nullptr);
      break;

    case CarriedObject::Behavior::REMOVE:
      get_sprites().set_lifted_item(nullptr);
      break;

    case CarriedObject::Behavior::KEEP:
      // The next state is now the owner and has incremented the refcount.
      break;
    }
  }

  std::string next_state_name;
  const CustomState* next_custom_state = nullptr;
  if (next_state != nullptr) {
    next_state_name = next_state->get_name();
    if (next_state_name == "custom") {
      next_custom_state = static_cast<const CustomState*>(next_state);
    }
  }
  get_lua_context().state_on_finished(
        *this, next_state_name, const_cast<CustomState*>(next_custom_state));  // TODO
}

/**
 * \copydoc Entity::State::set_map
 */
void CustomState::set_map(Map& map) {

  HeroState::set_map(map);

  if (carried_object != nullptr) {
    carried_object->set_map(map);
  }
}

/**
 * \copydoc Entity::State::update
 */
void CustomState::update() {

  HeroState::update();

  update_pushing();
  update_jumper();

  if (carried_object != nullptr) {
    carried_object->update();
  }
}

/**
 * \brief Updates the preparation of pushing.
 */
void CustomState::update_pushing() {

  if (!is_current_state()) {
    return;
  }

  if (is_suspended()) {
    return;
  }

  if (!get_can_push()) {
    return;
  }

  if (pushing_direction4 != -1) {
    // The entity is currently pushing.
    int movement_direction8 = get_wanted_movement_direction8();
    if (movement_direction8 == -1) {
      const std::shared_ptr<Movement> movement = get_entity().get_movement();
      if (movement != nullptr) {
        movement_direction8 = movement->get_displayed_direction4() * 2;
      }
    }
    if (movement_direction8 != pushing_direction4 * 2) {
      // The movement direction has changed: stop trying to push.
      pushing_direction4 = -1;
    }
  }
}

/**
 * \brief Updates the preparation of activating a jumper.
 */
void CustomState::update_jumper() {

  if (!is_current_state()) {
    return;
  }

  if (is_suspended()) {
    return;
  }

  if (!get_can_take_jumper() || current_jumper == nullptr) {
    return;
  }

  Hero& hero = get_entity();

  const int jump_direction8 = current_jumper->get_direction();
  if (!current_jumper->is_enabled()
      || current_jumper->is_being_removed()
      || !current_jumper->is_in_jump_position(hero, hero.get_bounding_box(), false)) {

    // Cancel the jumper preparation.
    current_jumper = nullptr;
    jumper_start_date = 0;
  }
  else if (System::now() >= jumper_start_date) {
    // Time to make the jump and everything is okay.
    hero.start_jumping(
        jump_direction8, current_jumper->get_jump_length(), true, true);
  }
}

/**
 * \copydoc Entity::State::set_suspended
 */
void CustomState::set_suspended(bool suspended) {

  HeroState::set_suspended(suspended);

  if (!suspended) {
    if (jumper_start_date != 0) {
      jumper_start_date += System::now() - get_when_suspended();
    }
    if (start_pushing_date != 0) {
      start_pushing_date += System::now() - get_when_suspended();
    }
  }

  if (carried_object != nullptr) {
    carried_object->set_suspended(suspended);
  }
}

/**
 * \copydoc Entity::State::draw_on_map
 */
void CustomState::draw_on_map() {

  Camera& camera = *get_entity().get_map().get_camera();
  get_lua_context().state_on_pre_draw(*this, camera);
  if (draw_override.is_empty()) {
    // Use the built-in default state draw.
    HeroState::draw_on_map();
  }
  else {
    get_lua_context().do_state_draw_override_function(draw_override, *this, camera);
  }
  get_lua_context().state_on_post_draw(*this, camera);
}

/**
 * \brief Returns the description of this state.
 * \return The description or an empty string.
 */
const std::string& CustomState::get_description() const {
  return description;
}

/**
 * \brief Sets the description of this state.
 * \param description The description or an empty string.
 */
void CustomState::set_description(const std::string& description) {
  this->description = description;
}

/**
 * \brief Returns whether the entity is visible during this state.
 * \return \c true if the entity is visible during this state.
 */
bool CustomState::is_visible() const {
  return visible;
}

/**
 * \brief Sets whether the entity is visible during this state.
 * \param visible \c true to show the entity during this state.
 */
void CustomState::set_visible(bool visible) {
  this->visible = visible;
}

/**
 * \brief Returns the Lua draw function of this entity if any.
 * \return The draw override or an empty ref.
 */
ScopedLuaRef CustomState::get_draw_override() const {
  return draw_override;
}

/**
 * \brief Sets the Lua draw function of this entity.
 * \param draw_override The draw override or an empty ref.
 */
void CustomState::set_draw_override(const ScopedLuaRef& draw_override) {
  this->draw_override = draw_override;
}

/**
 * \brief Returns whether the players controls the sprites direction in this state.
 * \return \c true if the player controls the sprites direction.
 */
bool CustomState::get_can_control_direction() const {
  return can_control_direction;
}

/**
 * \brief Sets whether the players controls the sprites direction in this state.
 * \param can_control_direction \c true if the player should control the sprites direction.
 */
void CustomState::set_can_control_direction(bool can_control_direction) {
  this->can_control_direction = can_control_direction;
}

/**
 * \copydoc Entity::State::is_direction_locked
 */
bool CustomState::is_direction_locked() const {
  return !get_can_control_direction();
}

/**
 * \copydoc Entity::State::get_wanted_movement_direction8
 */
int CustomState::get_wanted_movement_direction8() const {

  if (!is_current_state()) {
    return -1;
  }

  if (!get_can_control_direction()) {
    return -1;
  }

  if (get_entity().has_stream_action() &&
      !get_entity().get_stream_action()->get_stream().get_allow_movement()) {
    // On a blocking stream.
    return -1;
  }

  const GameCommands& commands = get_commands();
  return commands.get_wanted_direction8();
}

/**
 * \brief Sets whether the players controls the hero's movement in this state.
 * \param can_control_movement \c true if the player should control the hero's movement.
 */
void CustomState::set_can_control_movement(bool can_control_movement) {

  if (can_control_movement == this->can_control_movement) {
    return;
  }

  this->can_control_movement = can_control_movement;

  if (is_current_state()) {
    start_player_movement();
  }
}

/**
 * \copydoc Entity::State::can_control_movement
 */
bool CustomState::get_can_control_movement() const {
  return can_control_movement;
}

/**
 * \brief Sets up a movement controlled by the player.
 */
void CustomState::start_player_movement() {

  Hero& hero = get_entity();
  player_movement = std::make_shared<PlayerMovement>(
      hero.get_walking_speed()
  );
  hero.set_movement(player_movement);
}

/**
 * \copydoc Entity::State::is_touching_ground
 */
bool CustomState::is_touching_ground() const {
  return touching_ground;
}

/**
 * \brief Sets whether the entity is in contact with the ground.
 * \param touching_ground \c true if the entity is in contact with the ground.
 */
void CustomState::set_touching_ground(bool touching_ground) {
  this->touching_ground = touching_ground;
}

/**
 * \brief Returns whether the effect of the given ground is avoided.
 * \param ground A ground type.
 * \return \c true if this ground has no effect in this state.
 */
bool CustomState::is_affected_by_ground(Ground ground) const {

  bool ignored = ignored_grounds.find(ground) != ignored_grounds.end();
  return !ignored;
}

/**
 * \brief Sets whether the effect of the given ground is avoided.
 * \param ground A ground type.
 * \param affected \c true if this ground should have no effect.
 */
void CustomState::set_affected_by_ground(Ground ground, bool affected) {

  if (affected) {
    ignored_grounds.erase(ground);
  }
  else {
    ignored_grounds.insert(ground);
  }
}

/**
 * \copydoc Entity::State::can_avoid_deep_water
 */
bool CustomState::can_avoid_deep_water() const {
  return !is_affected_by_ground(Ground::DEEP_WATER);
}

/**
 * \copydoc Entity::State::can_avoid_hole
 */
bool CustomState::can_avoid_hole() const {
  return !is_affected_by_ground(Ground::HOLE);
}

/**
 * \copydoc Entity::State::can_avoid_ice
 */
bool CustomState::can_avoid_ice() const {
  return !is_affected_by_ground(Ground::ICE);
}

/**
 * \copydoc Entity::State::can_avoid_lava
 */
bool CustomState::can_avoid_lava() const {
  return !is_affected_by_ground(Ground::LAVA);
}

/**
 * \copydoc Entity::State::can_avoid_prickle
 */
bool CustomState::can_avoid_prickle() const {
  return !is_affected_by_ground(Ground::PRICKLE);
}

/**
 * \copydoc Entity::State::can_start_sword
 */
bool CustomState::get_can_start_sword() const {
  return can_start_sword;
}

/**
 * \brief Sets whether the sword can be used during this state.
 * \param can_start_sword \c true to allow the sword.
 */
void CustomState::set_can_start_sword(bool can_start_sword) {
  this->can_start_sword = can_start_sword;
}

/**
 * \copydoc Entity::State::can_use_shield
 */
bool CustomState::get_can_use_shield() const {
  return can_use_shield;
}

/**
 * \brief Sets whether the shield can be used during this state.
 * \param can_use_shield \c true to allow the shield.
 */
void CustomState::set_can_use_shield(bool can_use_shield) {
  this->can_use_shield = can_use_shield;
}

/**
 * \brief Returns whether equipment items can be used during this state.
 * \return \c true if items are allowed.
 */
bool CustomState::get_can_start_item() const {
  return can_start_item;
}

/**
 * \copydoc Entity::State::can_start_item
 */
bool CustomState::get_can_start_item(EquipmentItem& /* item */) const {
  return get_can_start_item();
}

/**
 * \brief Sets whether equipment items can be used during this state.
 * \param can_start_item \c true to allow items.
 */
void CustomState::set_can_start_item(bool can_start_item) {
  this->can_start_item = can_start_item;
}

/**
 * \brief Returns whether pushing is allowed from this state.
 * \return \c true if pushing is allowed.
 */
bool CustomState::get_can_push() const {
  return can_push;
}

/**
 * \brief Sets whether pushing is allowed from this state.
 * \param can_push \c true to allow to push.
 */
void CustomState::set_can_push(bool can_push) {
  this->can_push = can_push;
}

/**
 * \brief Returns the delay before pushing in this state.
 * \return The pushing delay in milliseconds.
 */
uint32_t CustomState::get_pushing_delay() const {
  return pushing_delay;
}

/**
 * \brief Sets the delay before pushing in this state.
 * \param pushing_delay The pushing delay in milliseconds.
 */
void CustomState::set_pushing_delay(uint32_t pushing_delay) {
  this->pushing_delay = pushing_delay;
}

/**
 * \brief Returns whether treasures can be picked during this state.
 * \return \c true if treasures can be picked.
 */
bool CustomState::get_can_pick_treasure() const {
  return can_pick_treasure;
}

/**
 * \copydoc Entity::State::can_pick_treasure
 */
bool CustomState::get_can_pick_treasure(EquipmentItem& /* item */) const {
  return get_can_pick_treasure();
}

/**
 * \brief Sets whether treasures can be picked during this state.
 * \param can_pick_treasure \c true to allow to pick treasures.
 */
void CustomState::set_can_pick_treasure(bool can_pick_treasure) {
  this->can_pick_treasure = can_pick_treasure;
}

/**
 * \copydoc Entity::State::can_take_stairs
 */
bool CustomState::get_can_take_stairs() const {
  return can_take_stairs;
}

/**
 * \brief Sets whether stairs can be used during this state.
 * \param can_take_stairs \c true to allow stairs.
 */
void CustomState::set_can_take_stairs(bool can_take_stairs) {
  this->can_take_stairs = can_take_stairs;
}

/**
 * \copydoc Entity::State::can_take_jumper
 */
bool CustomState::get_can_take_jumper() const {
  return can_take_jumper;
}

/**
 * \brief Sets whether jumpers can be used during this state.
 * \param can_take_jumper \c true to allow jumpers.
 */
void CustomState::set_can_take_jumper(bool can_take_jumper) {
  this->can_take_jumper = can_take_jumper;
}

/**
 * \brief Returns the delay before jumpers activate.
 * \return The jumper delay in milliseconds.
 */
uint32_t CustomState::get_jumper_delay() const {
  return jumper_delay;
}

/**
 * \brief Sets the delay before jumpers activate.
 * \param jumper_delay The jumper delay in milliseconds.
 */
void CustomState::set_jumper_delay(uint32_t jumper_delay) {
  this->jumper_delay = jumper_delay;
}

/**
 * \copydoc Entity::State::get_previous_carried_object_behavior
 */
CarriedObject::Behavior CustomState::get_previous_carried_object_behavior() const {
  return previous_carried_object_behavior;
}

/**
 * \brief Sets what happens to an object that was carried the previous state.
 * \param behavior The action to do.
 */
void CustomState::set_previous_carried_object_behavior(CarriedObject::Behavior behavior) {
  this->previous_carried_object_behavior = behavior;
}

/**
 * \copydoc Entity::State::get_carried_object
 */
std::shared_ptr<CarriedObject> CustomState::get_carried_object() const {
  return carried_object;
}

/**
 * \copydoc Entity::State::notify_position_changed
 */
void CustomState::notify_position_changed() {

  Entity::State::notify_position_changed();

  // Stop the preparation to a jump if any.
  cancel_jumper();
}

/**
 * \copydoc Entity::State::notify_obstacle_reached
 */
void CustomState::notify_obstacle_reached() {

  Entity::State::notify_obstacle_reached();

  // See if we should prepare to push.
  if (get_can_push()) {
    Hero& hero = get_entity();
    Equipment& equipment = get_equipment();
    if (hero.is_facing_point_on_obstacle() &&   // He is really facing an obstacle.
        equipment.has_ability(Ability::PUSH)    // He is able to push.
    ) {
      uint32_t now = System::now();
      if (pushing_direction4 == -1) {
        // Start state "pushing" after a delay.
        start_pushing_date = now + get_pushing_delay();
        pushing_direction4 = hero.get_animation_direction();
      }
      if (pushing_direction4 != -1 && now >= start_pushing_date) {
        hero.start_pushing();
      }
    }
  }
}

/**
 * \copydoc Entity::State::notify_layer_changed
 */
void CustomState::notify_layer_changed() {

  if (carried_object != nullptr) {
    carried_object->set_layer(get_entity().get_layer());
  }
}

/**
 * \copydoc Entity::State::notify_jumper_activated
 */
void CustomState::notify_jumper_activated(Jumper& jumper) {

  if (!get_can_take_jumper()) {
    return;
  }
  if (&jumper == current_jumper.get()) {
    // We already know.
    return;
  }

  // Add a small delay before jumping.
  current_jumper = std::static_pointer_cast<Jumper>(jumper.shared_from_this());
  jumper_start_date = System::now() + get_jumper_delay();
  update_jumper();
}

/**
 * \brief Cancels the jumper preparation that was ongoing if any.
 */
void CustomState::cancel_jumper() {

  if (current_jumper != nullptr) {
    current_jumper = nullptr;
    jumper_start_date = 0;
  }
}

}

