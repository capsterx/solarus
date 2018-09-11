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
  description_(description),
  can_control_direction_(true),
  can_control_movement_(true),
  player_movement_(),
  ignored_grounds_() {

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
  return description_;
}

/**
 * \brief Sets the description of this state.
 * \param description The description or an empty string.
 */
void CustomState::set_description(const std::string& description) {
  this->description_ = description;
}

/**
 * \brief Returns whether the players controls the sprites direction in this state.
 * \return \c true if the player controls the sprites direction.
 */
bool CustomState::get_can_control_direction() const {
  return can_control_direction_;
}

/**
 * \brief Sets whether the players controls the sprites direction in this state.
 * \param can_control_direction \c true if the player should control the sprites direction.
 */
void CustomState::set_can_control_direction(bool can_control_direction) {
  this->can_control_direction_ = can_control_direction;
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
 * \brief Returns whether the players controls the hero's movement in this state.
 * \return \c true if the player controls the hero's movement.
 */
bool CustomState::get_can_control_movement() const {
  return can_control_movement_;
}

/**
 * \brief Sets whether the players controls the hero's movement in this state.
 * \param can_control_movement \c true if the player should control the hero's movement.
 */
void CustomState::set_can_control_movement(bool can_control_movement) {

  if (can_control_movement == can_control_movement_) {
    return;
  }

  can_control_movement_ = can_control_movement;

  if (is_current_state()) {
    start_player_movement();
  }
}

/**
 * \copydoc Entity::State::can_control_movement
 */
bool CustomState::can_control_movement() const {
  return get_can_control_movement();
}

/**
 * \brief Sets up a movement controlled by the player.
 */
void CustomState::start_player_movement() {

  Hero& hero = get_entity();
  player_movement_ = std::make_shared<PlayerMovement>(
      hero.get_walking_speed()
  );
  hero.set_movement(player_movement_);
}

/**
 * \brief Returns whether the effect of the given ground is avoided.
 * \param ground A ground type.
 * \return \c true if this ground has no effect in this state.
 */
bool CustomState::is_affected_by_ground(Ground ground) const {

  bool ignored = ignored_grounds_.find(ground) != ignored_grounds_.end();
  return !ignored;
}

/**
 * \brief Sets whether the effect of the given ground is avoided.
 * \param ground A ground type.
 * \param affected \c true if this ground should have no effect.
 */
void CustomState::set_affected_by_ground(Ground ground, bool affected) {

  if (affected) {
    ignored_grounds_.erase(ground);
  }
  else {
    ignored_grounds_.insert(ground);
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
  player_movement_ = nullptr;

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

}

