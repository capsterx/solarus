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
#include "solarus/hero/CustomState.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/movements/PlayerMovement.h"

namespace Solarus {

/**
 * \brief Constructor.
 * \param name Name of this state or an empty string.
 */
CustomState::CustomState(
    const std::string& name):
  HeroState("custom"),
  name_(name),
  can_control_direction_(true),
  can_control_movement_(true),
  player_movement_() {

}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& CustomState::get_lua_type_name() const {
  return LuaContext::state_module_name;
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
 * \return \c true if the player should control the sprites direction.
 */
void CustomState::set_can_control_direction(bool can_control_direction) {
  this->can_control_direction_ = can_control_direction;
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
 * \return \c true if the player should control the hero's movement.
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
 * \copydoc EntityState::get_wanted_movement_direction8
 */
int CustomState::get_wanted_movement_direction8() const {

  if (player_movement_ == nullptr ||
      !get_can_control_movement()) {
    return -1;
  }

  return player_movement_->get_wanted_direction8();
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
 * \brief copydoc EntityState::start
 */
void CustomState::start(const State* previous_state) {

  HeroState::start(previous_state);

  if (get_can_control_movement()) {
    start_player_movement();
  }
}

/**
 * \brief copydoc EntityState::stop
 */
void CustomState::stop(const State* next_state) {

  HeroState::stop(next_state);

  if (get_can_control_movement()) {
    get_entity().clear_movement();
  }
  player_movement_ = nullptr;
}

/**
 * \copydoc EntityState::is_direction_locked
 */
bool CustomState::is_direction_locked() const {
  return !get_can_control_direction();
}

/**
 * \copydoc EntityState::can_control_movement
 */
bool CustomState::can_control_movement() const {
  return get_can_control_movement();
}

}

