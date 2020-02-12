/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
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
#include "solarus/core/EquipmentItem.h"
#include "solarus/core/Geometry.h"
#include "solarus/core/Map.h"
#include "solarus/core/System.h"
#include "solarus/entities/Block.h"
#include "solarus/entities/Crystal.h"
#include "solarus/entities/CrystalBlock.h"
#include "solarus/entities/Destructible.h"
#include "solarus/entities/Door.h"
#include "solarus/entities/Enemy.h"
#include "solarus/entities/Hero.h"
#include "solarus/entities/Jumper.h"
#include "solarus/entities/Npc.h"
#include "solarus/entities/Sensor.h"
#include "solarus/entities/Separator.h"
#include "solarus/entities/Stairs.h"
#include "solarus/entities/Stream.h"
#include "solarus/entities/StreamAction.h"
#include "solarus/entities/Switch.h"
#include "solarus/entities/Teletransporter.h"
#include "solarus/hero/CustomState.h"
#include "solarus/hero/PushingState.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/movements/PlayerMovement.h"

namespace Solarus {

/**
 * \brief Constructor.
 * \param lua_context The Lua context.
 * \param description Description of this state or an empty string.
 */
CustomState::CustomState(
    LuaContext& lua_context,
    const std::string& description):
  HeroState("custom"),
  lua_context(lua_context),
  description(description),
  visible(true),
  draw_override(),
  can_control_direction(true),
  can_control_movement(true),
  player_movement(),
  touching_ground(true),
  ignored_grounds(),
  can_come_from_bad_ground(true),
  can_be_hurt(true),
  can_be_hurt_callback(),
  can_start_sword(true),
  can_cut(true),
  can_cut_callback(),
  can_use_shield(true),
  can_start_item(true),
  can_start_items(),
  can_interact(true),
  can_grab(true),
  can_push(true),
  pushing_delay(1000),
  pushing_direction4(-1),
  start_pushing_date(0),
  can_pick_treasure(true),
  can_take_teletransporter(true),
  can_take_switch(true),
  can_take_stream(true),
  can_take_stairs(true),
  can_take_jumper(true),
  current_jumper(nullptr),
  jumper_start_date(0),
  jumper_delay(200),
  previous_carried_object_behavior(CarriedObject::Behavior::THROW),
  carried_object(nullptr),
  can_traverse_entities_general(),
  can_traverse_entities_type(),
  can_traverse_grounds() {

}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& CustomState::get_lua_type_name() const {
  return LuaContext::state_module_name;
}

/**
 * \brief Returns the Lua context of this state.
 *
 * TODO store in EntityState instead of hiding a method
 *
 * \return The Lua context.
 */
LuaContext& CustomState::get_lua_context() {
  return lua_context;
}

/**
 * \copydoc Entity::State::start
 */
void CustomState::start(const State* previous_state) {

  HeroState::start(previous_state);

  Hero& hero = get_entity();
  HeroSprites& sprites = get_sprites();
  if (!is_affected_by_ground(hero.get_ground_below())) {
    hero.set_walking_speed(hero.get_normal_walking_speed());
    sprites.destroy_ground();
  }
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
 * \copydoc Entity::State::notify_map_opening_transition_finished
 */
void CustomState::notify_map_started(
    Map& map, const std::shared_ptr<Destination>& destination) {

  HeroState::notify_map_started(map, destination);

  get_lua_context().state_on_map_started(*this, map, destination);
}

/**
 * \copydoc Entity::State::notify_map_opening_transition_finished
 */
void CustomState::notify_map_opening_transition_finished(
    Map& map, const std::shared_ptr<Destination>& destination) {

  HeroState::notify_map_opening_transition_finished(map, destination);

  get_lua_context().state_on_map_opening_transition_finished(*this, map, destination);
}

/**
 * \copydoc Entity::State::notify_map_opening_transition_finished
 */
void CustomState::notify_map_finished() {

  HeroState::notify_map_finished();

  get_lua_context().state_on_map_finished(*this);
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

  get_lua_context().state_on_update(*this);
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

  get_lua_context().state_on_suspended(*this, suspended);
}

/**
 * \copydoc Entity::State::notify_input
 */
bool CustomState::notify_input(const InputEvent& event) {
  return get_lua_context().state_on_input(*this, event);
}

/**
 * \copydoc Entity::State::notify_command_pressed
 */
void CustomState::notify_command_pressed(GameCommand command) {

  // See if the state script handles the command.
  if (get_lua_context().state_on_command_pressed(*this, command)) {
    return;
  }

  if (command == GameCommand::ACTION) {
    Hero& hero = get_entity();
    Entity* facing_entity = hero.get_facing_entity();
    bool facing_entity_interaction = false;
    if (facing_entity != nullptr &&
        get_can_interact()) {
      if (get_commands_effects().get_action_key_effect() == CommandsEffects::ACTION_KEY_NONE ||
          get_commands_effects().is_action_key_acting_on_facing_entity()
      ) {
        // Action on the facing entity.
        facing_entity_interaction = facing_entity->notify_action_command_pressed();
      }
    }

    if (!facing_entity_interaction) {
      // The event was not handled by the facing entity.
      if (hero.is_facing_point_on_obstacle() &&
          get_can_grab() &&
          hero.can_grab()
      ) {
        // Grab an obstacle.
        hero.start_grabbing();
      }
    }
  }

  Entity::State::notify_command_pressed(command);
}

/**
 * \copydoc Entity::State::notify_command_released
 */
void CustomState::notify_command_released(GameCommand command) {

  // See if the state script handles the command.
  if (get_lua_context().state_on_command_released(*this, command)) {
    return;
  }

  Entity::State::notify_command_released(command);
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

  if (!get_can_control_movement()) {
    const std::shared_ptr<const Movement>& movement = get_entity().get_movement();
    if (movement == nullptr) {
      return -1;
    }
    return static_cast<int>((movement->get_angle() + Geometry::PI / 8.0) * 8.0 / Geometry::TWO_PI);
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
 * \brief Returns the info about whether the entity can traverse a
 * type of entity in this state.
 * \param type Type of entity to test.
 * \return The corresponding traversable property.
 */
const TraversableInfo& CustomState::get_can_traverse_entity_info(
    EntityType type) {

  // Find the obstacle settings.
  const auto it = can_traverse_entities_type.find(type);
  if (it != can_traverse_entities_type.end()) {
    // This entity type overrides the general setting.
    return it->second;
  }

  return can_traverse_entities_general;
}

/**
 * \brief Sets whether the entity can traverse other entities in this state.
 *
 * This applies to entities that are not overridden by
 * set_can_traverse_entities(EntityType, bool)
 * or
 * set_can_traverse_entities(EntityType, const ScopedLuaRef&).
 *
 * \param traversable \c true to allow the entity to traverse other entities.
 */
void CustomState::set_can_traverse_entities(bool traversable) {

  can_traverse_entities_general = TraversableInfo(
      get_lua_context(),
      traversable
  );
}

/**
 * \brief Registers a Lua function to decide if the entity can traverse
 * other entities in this state.
 *
 * This applies to entities that are not overridden by
 * set_can_traverse_entities(EntityType, bool)
 * or
 * set_can_traverse_entities(EntityType, const ScopedLuaRef&).
 *
 * \param traversable_test_ref Lua ref to a function that will do the test.
 */
void CustomState::set_can_traverse_entities(const ScopedLuaRef& traversable_test_ref) {

  can_traverse_entities_general = TraversableInfo(
      get_lua_context(),
      traversable_test_ref
  );
}

/**
 * \brief Restores the default setting of whether the entity can
 * traverse other entities in this state.
 *
 * This reverts the settings of previous calls to
 * set_can_traverse_entities(bool)
 * and
 * set_can_traverse_entities(const ScopedLuaRef&).
 */
void CustomState::reset_can_traverse_entities() {

  can_traverse_entities_general = TraversableInfo();
}

/**
 * \brief Sets whether the entity can traverse other entities
 * of the specified type in this state.
 *
 * This overrides for a specific type whatever was set by
 * set_can_traverse_entities(bool)
 * or
 * set_can_traverse_entities(const ScopedLuaRef&).
 *
 * \param type A type of entities.
 * \param traversable \c true to allow the entity to traverse other entities
 * of the specified type in this state
 */
void CustomState::set_can_traverse_entities(
    EntityType type,
    bool traversable
) {

  can_traverse_entities_type[type] = TraversableInfo(
      get_lua_context(),
      traversable
  );
}

/**
 * \brief Registers a Lua function to decide if the entity can
 * traverse other entities of the specified type in this state.
 *
 * This overrides for a specific type whatever was set by
 * set_can_traverse_entities(bool)
 * or
 * set_can_traverse_entities(const ScopedLuaRef&).
 *
 * \param type A type of entities.
 * \param traversable_test_ref Lua ref to a function that will do the test.
 */
void CustomState::set_can_traverse_entities(
    EntityType type,
    const ScopedLuaRef& traversable_test_ref
) {

  can_traverse_entities_type[type] = TraversableInfo(
      get_lua_context(),
      traversable_test_ref
  );
}

/**
 * \brief Restores the default setting of whether the entity can
 * traverse other entities of the specified type in this state.
 *
 * This reverts the settings of previous calls to
 * set_can_traverse_entities(EntityType, bool)
 * and
 * set_can_traverse_entities(EntityType, const ScopedLuaRef&).
 *
 * \param type A type of entities.
 */
void CustomState::reset_can_traverse_entities(EntityType type) {

  can_traverse_entities_type.erase(type);
}

/**
 * \copydoc Entity::State::is_hero_obstacle
 */
bool CustomState::is_hero_obstacle(Hero& hero) {

  const TraversableInfo& info = get_can_traverse_entity_info(hero.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, hero);
  }
  return Hero::State::is_hero_obstacle(hero);
}

/**
 * \copydoc Entity::State::is_block_obstacle
 */
bool CustomState::is_block_obstacle(Block& block) {

  const TraversableInfo& info = get_can_traverse_entity_info(block.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, block);
  }
  return Hero::State::is_block_obstacle(block);
}

/**
 * \copydoc Entity::State::is_teletransporter_obstacle
 */
bool CustomState::is_teletransporter_obstacle(Teletransporter& teletransporter) {

  const TraversableInfo& info = get_can_traverse_entity_info(teletransporter.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, teletransporter);
  }
  return Hero::State::is_teletransporter_obstacle(teletransporter);
}

/**
 * \copydoc Entity::State::is_stream_obstacle
 */
bool CustomState::is_stream_obstacle(Stream& stream) {

  const TraversableInfo& info = get_can_traverse_entity_info(stream.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, stream);
  }
  return Hero::State::is_stream_obstacle(stream);
}

/**
 * \copydoc Entity::State::is_stairs_obstacle
 */
bool CustomState::is_stairs_obstacle(Stairs& stairs) {

  const TraversableInfo& info = get_can_traverse_entity_info(stairs.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, stairs);
  }
  return Hero::State::is_stairs_obstacle(stairs);
}

/**
 * \copydoc Entity::State::is_sensor_obstacle
 */
bool CustomState::is_sensor_obstacle(Sensor& sensor) {

  const TraversableInfo& info = get_can_traverse_entity_info(sensor.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, sensor);
  }
  return Hero::State::is_sensor_obstacle(sensor);
}

/**
 * \copydoc Entity::State::is_switch_obstacle
 */
bool CustomState::is_switch_obstacle(Switch& sw) {

  const TraversableInfo& info = get_can_traverse_entity_info(sw.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, sw);
  }
  return Hero::State::is_switch_obstacle(sw);
}

/**
 * \copydoc Entity::State::is_raised_block_obstacle
 */
bool CustomState::is_raised_block_obstacle(CrystalBlock& raised_block) {

  const TraversableInfo& info = get_can_traverse_entity_info(raised_block.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, raised_block);
  }
  return Hero::State::is_raised_block_obstacle(raised_block);
}

/**
 * \copydoc Entity::State::is_crystal_obstacle
 */
bool CustomState::is_crystal_obstacle(Crystal& crystal) {

  const TraversableInfo& info = get_can_traverse_entity_info(crystal.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, crystal);
  }
  return Hero::State::is_crystal_obstacle(crystal);
}

/**
 * \copydoc Entity::State::is_npc_obstacle
 */
bool CustomState::is_npc_obstacle(Npc& npc) {

  const TraversableInfo& info = get_can_traverse_entity_info(npc.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, npc);
  }
  return Hero::State::is_npc_obstacle(npc);
}

/**
 * \copydoc Entity::State::is_door_obstacle
 */
bool CustomState::is_door_obstacle(Door& door) {

  const TraversableInfo& info = get_can_traverse_entity_info(door.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, door);
  }
  return Hero::State::is_door_obstacle(door);
}

/**
 * \copydoc Entity::State::is_enemy_obstacle
 */
bool CustomState::is_enemy_obstacle(Enemy& enemy) {

  const TraversableInfo& info = get_can_traverse_entity_info(enemy.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, enemy);
  }
  return Hero::State::is_enemy_obstacle(enemy);
}

/**
 * \copydoc Entity::State::is_jumper_obstacle
 */
bool CustomState::is_jumper_obstacle(Jumper& jumper, const Rectangle& candidate_position) {

  const TraversableInfo& info = get_can_traverse_entity_info(jumper.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, jumper);
  }
  return Hero::State::is_jumper_obstacle(jumper, candidate_position);
}

/**
 * \copydoc Entity::State::is_destructible_obstacle
 */
bool CustomState::is_destructible_obstacle(Destructible& destructible) {

  const TraversableInfo& info = get_can_traverse_entity_info(destructible.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, destructible);
  }
  return Hero::State::is_destructible_obstacle(destructible);
}

/**
 * \copydoc Entity::State::is_separator_obstacle
 */
bool CustomState::is_separator_obstacle(Separator& separator) {

  const TraversableInfo& info = get_can_traverse_entity_info(separator.get_type());
  if (!info.is_empty()) {
    return !info.is_traversable(*this, separator);
  }
  return Hero::State::is_separator_obstacle(separator);
}

/**
 * \brief Returns whether the entity can traverse a kind of ground in this state.
 * \param ground A kind of ground.
 * \return \c true if this custom entity can traverse this kind of ground.
 */
bool CustomState::get_can_traverse_ground(Ground ground) const {

  const auto& it = can_traverse_grounds.find(ground);

  if (it != can_traverse_grounds.end()) {
    // Return the boolean value that was set.
    return it->second;
  }

  // Return a default value.
  switch (ground) {

    case Ground::EMPTY:
    case Ground::TRAVERSABLE:
    case Ground::GRASS:
    case Ground::ICE:
    case Ground::LADDER:
    case Ground::DEEP_WATER:
    case Ground::SHALLOW_WATER:
    case Ground::HOLE:
    case Ground::PRICKLE:
    case Ground::LAVA:
      return true;

    case Ground::WALL:
    case Ground::LOW_WALL:
    case Ground::WALL_TOP_RIGHT:
    case Ground::WALL_TOP_LEFT:
    case Ground::WALL_BOTTOM_LEFT:
    case Ground::WALL_BOTTOM_RIGHT:
    case Ground::WALL_TOP_RIGHT_WATER:
    case Ground::WALL_TOP_LEFT_WATER:
    case Ground::WALL_BOTTOM_LEFT_WATER:
    case Ground::WALL_BOTTOM_RIGHT_WATER:
      return false;
  }

  return false;
}

/**
 * \brief Sets whether the entity can traverse a kind of ground in this state.
 * \param ground A kind of ground.
 * \param traversable \c true to make this kind of ground traversable.
 */
void CustomState::set_can_traverse_ground(Ground ground, bool traversable) {

  can_traverse_grounds[ground] = traversable;
}

/**
 * \copydoc Entity::State::is_traversable_obstacle
 */
bool CustomState::is_traversable_obstacle() const {

  return !get_can_traverse_ground(Ground::TRAVERSABLE);
}

/**
 * \copydoc Entity::State::is_wall_obstacle
 */
bool CustomState::is_wall_obstacle() const {

  return !get_can_traverse_ground(Ground::WALL);
}

/**
 * \copydoc Entity::State::is_low_wall_obstacle
 */
bool CustomState::is_low_wall_obstacle() const {

  return !get_can_traverse_ground(Ground::LOW_WALL);
}

/**
 * \copydoc Entity::State::is_grass_obstacle
 */
bool CustomState::is_grass_obstacle() const {

  return !get_can_traverse_ground(Ground::GRASS);
}

/**
 * \copydoc Entity::State::is_shallow_water_obstacle
 */
bool CustomState::is_shallow_water_obstacle() const {

  return !get_can_traverse_ground(Ground::SHALLOW_WATER);
}

/**
 * \copydoc Entity::State::is_deep_water_obstacle
 */
bool CustomState::is_deep_water_obstacle() const {

  return !get_can_traverse_ground(Ground::DEEP_WATER);
}

/**
 * \copydoc Entity::State::is_hole_obstacle
 */
bool CustomState::is_hole_obstacle() const {

  return !get_can_traverse_ground(Ground::HOLE);
}

/**
 * \copydoc Entity::State::is_ice_obstacle
 */
bool CustomState::is_ice_obstacle() const {

  return !get_can_traverse_ground(Ground::ICE);
}

/**
 * \copydoc Entity::State::is_lava_obstacle
 */
bool CustomState::is_lava_obstacle() const {

  return !get_can_traverse_ground(Ground::LAVA);
}

/**
 * \copydoc Entity::State::is_prickle_obstacle
 */
bool CustomState::is_prickle_obstacle() const {

  return !get_can_traverse_ground(Ground::PRICKLE);
}

/**
 * \copydoc Entity::State::is_ladder_obstacle
 */
bool CustomState::is_ladder_obstacle() const {

  return !get_can_traverse_ground(Ground::LADDER);
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
 * \copydoc Entity::State::get_can_come_from_bad_ground
 */
bool CustomState::get_can_come_from_bad_ground() const {
  return can_come_from_bad_ground;
}

/**
 * \brief Sets whether the current position can be considered
 * as a place where to come back after a bad ground.
 * \param can_come_from_bad_ground \c true to allow to save the solid
 * ground position.
 */
void CustomState::set_can_come_from_bad_ground(bool can_come_from_bad_ground) {
  this->can_come_from_bad_ground = can_come_from_bad_ground;
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
 * \copydoc Entity::State::is_affected_by_shallow_water()
 */
bool CustomState::is_affected_by_shallow_water() const {
  return is_affected_by_ground(Ground::SHALLOW_WATER);
}

/**
 * \copydoc Entity::State::is_affected_by_grass
 */
bool CustomState::is_affected_by_grass() const {
  return is_affected_by_ground(Ground::GRASS);
}

/**
 * \copydoc Entity::State::is_affected_by_ladder
 */
bool CustomState::is_affected_by_ladder() const {
  return is_affected_by_ground(Ground::LADDER);
}

/**
 * \copydoc Entity::State::get_can_be_hurt
 */
bool CustomState::get_can_be_hurt(Entity* attacker) {

  if (!can_be_hurt_callback.is_empty()) {
    return get_lua_context().do_state_can_be_hurt_function(
        can_be_hurt_callback, *this, attacker);
  }
  return can_be_hurt;
}

/**
 * \brief Sets whether the entity can be hurt during this state.
 * \param can_be_hurt \c true to allow to hurt the entity.
 */
void CustomState::set_can_be_hurt(bool can_be_hurt) {
  this->can_be_hurt = can_be_hurt;
  this->can_be_hurt_callback.clear();
}

/**
 * \brief Sets whether the entity can be hurt during this state.
 * \param can_be_hurt Boolean function deciding if the entity can be hurt.
 */
void CustomState::set_can_be_hurt(const ScopedLuaRef& can_be_hurt) {
  this->can_be_hurt = true;
  this->can_be_hurt_callback = can_be_hurt;
}

/**
 * \copydoc Entity::State::is_cutting_with_sword
 */
bool CustomState::is_cutting_with_sword(Entity& entity) {
  return get_can_cut(&entity);
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
 * \brief Returns whether an entity can be cut with the sword.
 * \param entity The entity to test or nullptr.
 */
bool CustomState::get_can_cut(Entity* entity) {

  if (!can_cut_callback.is_empty()) {
    return get_lua_context().do_state_can_cut_function(
        can_cut_callback, *this, entity);
  }
  return can_cut;
}

/**
 * \brief Sets whether entities can be cut with the sword.
 * \param can_cut \c true to allow to cut entities.
 */
void CustomState::set_can_cut(bool can_cut) {
  this->can_cut = can_cut;
  this->can_cut_callback.clear();
}

/**
 * \brief Sets whether entities can be cut with the sword.
 * \param can_cut Boolean function deciding if entities can be cut.
 */
void CustomState::set_can_cut(const ScopedLuaRef& can_cut) {
  this->can_cut = true;
  this->can_cut_callback = can_cut;
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
 * \copydoc Entity::State::can_start_item
 */
bool CustomState::get_can_start_item(EquipmentItem& item) const {
  return get_can_start_item(item.get_name());
}

/**
 * \brief Returns whether an equipment item can be used during this state.
 * \param item_id Id of the item to test, or an empty string to mean
 * items in general.
 * \return \c true if an equipment item is allowed.
 */
bool CustomState::get_can_start_item(const std::string& item_id) const {

  if (!item_id.empty()) {
    auto it = can_start_items.find(item_id);
    if (it != can_start_items.end()) {
      return it->second;
    }
  }
  return can_start_item;
}

/**
 * \brief Sets whether an equipment item can be used during this state.
 * \param item_id Id of the item to configure, or an empty string to mean
 * items in general.
 * \param can_start_item \c true to allow to use an equipment item.
 */
void CustomState::set_can_start_item(const std::string& item_id, bool can_start_item) {

  if (item_id.empty()) {
    this->can_start_item = can_start_item;
    return;
  }

  can_start_items[item_id] = can_start_item;
}

/**
 * \brief Returns whether interacting is allowed from this state.
 * \return \c true if interacting with the facing entity is allowed.
 */
bool CustomState::get_can_interact() const {
  return can_interact;
}

/**
 * \brief Sets whether pushing is allowed from this state.
 * \param can_push \c true to allow to interacting with the facing entity.
 */
void CustomState::set_can_interact(bool can_interact) {
  this->can_interact = can_interact;
}

/**
 * \brief Returns whether grabbing is allowed from this state.
 * \return \c true if grabbing is allowed.
 */
bool CustomState::get_can_grab() const {
  return can_grab;
}

/**
 * \brief Sets whether pushing is allowed from this state.
 * \param can_push \c true to allow to grab.
 */
void CustomState::set_can_grab(bool can_grab) {
  this->can_grab = can_grab;
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
 * \copydoc EntityState::can_avoid_teletransporter
 */
bool CustomState::can_avoid_teletransporter() const {
  return !get_can_take_teletransporter();
}

/**
 * \brief Returns whether teletransporters can be used during this state.
 * \return \c true if teletransporters are allowed.
 */
bool CustomState::get_can_take_teletransporter() const {
  return can_take_teletransporter;
}

/**
 * \brief Sets whether teletransporters can be used during this state.
 * \param can_take_teletransporter \c true to allow teletransporters.
 */
void CustomState::set_can_take_teletransporter(bool can_take_teletransporter) {
  this->can_take_teletransporter = can_take_teletransporter;
}

/**
 * \copydoc EntityState::can_avoid_switch
 */
bool CustomState::can_avoid_switch() const {
  return !get_can_take_switch();
}

/**
 * \brief Returns whether switches can be used during this state.
 * \return \c true if switches are allowed.
 */
bool CustomState::get_can_take_switch() const {
  return can_take_switch;
}

/**
 * \brief Sets whether switches can be used during this state.
 * \param can_take_switch \c true to allow switches.
 */
void CustomState::set_can_take_switch(bool can_take_switch) {
  this->can_take_switch = can_take_switch;
}

/**
 * \copydoc EntityState::get_can_take_stream
 */
bool CustomState::can_avoid_stream(const Stream& /* stream */) const {
  return !get_can_take_stream();
}

/**
 * \brief Returns whether streams can be used during this state.
 * \return \c true if streams are allowed.
 */
bool CustomState::get_can_take_stream() const {
  return can_take_stream;
}

/**
 * \brief Sets whether streams can be used during this state.
 * \param can_take_stream \c true to allow streams.
 */
void CustomState::set_can_take_stream(bool can_take_stream) {
  this->can_take_stream = can_take_stream;
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

  HeroState::notify_position_changed();

  // Stop the preparation to a jump if any.
  cancel_jumper();

  get_lua_context().state_on_position_changed(
        *this, get_entity().get_xy(), get_entity().get_layer());
}

/**
 * \copydoc Entity::State::notify_layer_changed
 */
void CustomState::notify_layer_changed() {

  HeroState::notify_layer_changed();

  if (carried_object != nullptr) {
    carried_object->set_layer(get_entity().get_layer());
  }
}

/**
 * \copydoc Entity::State::notify_ground_below_changed
 */
void CustomState::notify_ground_below_changed() {

  HeroState::notify_ground_below_changed();

  get_lua_context().state_on_ground_below_changed(
        *this, get_entity().get_ground_below());
}

/**
 * \copydoc Entity::State::notify_obstacle_reached
 */
void CustomState::notify_obstacle_reached() {

  HeroState::notify_obstacle_reached();

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

  const std::shared_ptr<Movement>& movement = get_entity().get_movement();
  if (movement != nullptr) {
    get_lua_context().state_on_obstacle_reached(*this, *movement);
  }
}

/**
 * \copydoc Entity::State::notify_movement_started
 */
void CustomState::notify_movement_started() {

  HeroState::notify_movement_started();

  const std::shared_ptr<Movement>& movement = get_entity().get_movement();
  if (movement != nullptr &&
      get_entity().are_movement_notifications_enabled()) {
    get_lua_context().state_on_movement_started(*this, *movement);
  }
}

/**
 * \copydoc Entity::State::notify_movement_finished
 */
void CustomState::notify_movement_finished() {

  HeroState::notify_movement_finished();

  if (get_entity().are_movement_notifications_enabled()) {
    get_lua_context().state_on_movement_finished(*this);
  }
}

/**
 * \copydoc Entity::State::notify_movement_changed
 */
void CustomState::notify_movement_changed() {

  HeroState::notify_movement_changed();

  const std::shared_ptr<Movement>& movement = get_entity().get_movement();
  if (movement != nullptr &&
      get_entity().are_movement_notifications_enabled()) {
    get_lua_context().state_on_movement_changed(*this, *movement);
  }
}

/**
 * \copydoc Entity::State::notify_walking_speed_changed
 */
void CustomState::notify_walking_speed_changed() {

  if (get_can_control_movement() && player_movement != nullptr) {
    player_movement->set_moving_speed(get_entity().get_walking_speed());
  }
}

/**
 * \copydoc Entity::State::notify_jumper_activated
 */
void CustomState::notify_jumper_activated(Jumper& jumper) {

  HeroState::notify_jumper_activated(jumper);

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

/**
 * \copydoc Entity::State::notify_attacked_enemy
 */
void CustomState::notify_attacked_enemy(
    EnemyAttack attack,
    Enemy& victim,
    Sprite* victim_sprite,
    const EnemyReaction::Reaction& result,
    bool /* killed */) {

  get_lua_context().state_on_attacked_enemy(*this, victim, victim_sprite, attack, result);
}

}

