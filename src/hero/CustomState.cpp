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
#include "solarus/core/Map.h"
#include "solarus/entities/Hero.h"
#include "solarus/entities/Stream.h"
#include "solarus/entities/StreamAction.h"
#include "solarus/hero/CustomState.h"
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
  can_pick_treasure(true),
  can_take_stairs(true),
  can_take_jumper(true) {

}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& CustomState::get_lua_type_name() const {
  return LuaContext::state_module_name;
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
 * \copydoc Entity::State::start
 */
void CustomState::start(const State* previous_state) {

  HeroState::start(previous_state);

  if (get_can_control_movement()) {
    start_player_movement();
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
  player_movement = nullptr;

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
 * \copydoc Entity::State::update
 */
void CustomState::update() {

  HeroState::update();

  // TODO
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

}

