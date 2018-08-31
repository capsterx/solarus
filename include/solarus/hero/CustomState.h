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
#ifndef SOLARUS_HERO_CUSTOM_STATE_H
#define SOLARUS_HERO_CUSTOM_STATE_H

#include "solarus/core/Common.h"
#include "solarus/hero/HeroState.h"

namespace Solarus {

class PlayerMovement;

/**
 * \brief The state "custom" of the hero.
 *
 * Delegates everything to a Lua object of type state.
 */
class CustomState: public HeroState {

  public:

    explicit CustomState(const std::string& name);
    const std::string& get_lua_type_name() const override;

    bool get_can_control_direction() const;
    void set_can_control_direction(bool can_control_direction);
    bool get_can_control_movement() const;
    void set_can_control_movement(bool can_control_movement);

    // HeroState overrides.
    void start(const State* previous_state) override;
    void stop(const State* next_state) override;

    bool is_direction_locked() const override;
    bool can_control_movement() const override;
    int get_wanted_movement_direction8() const override;

  private:

    void start_player_movement();

    std::string name_;                      /**< Name of this state or an empty string. */
    bool can_control_direction_;            /**< Whether the player controls the sprites direction. */
    bool can_control_movement_;             /**< Whether the player controls the hero's movement. */
    std::shared_ptr<PlayerMovement>
        player_movement_;                   /**< The movement, if controlled by the player. */
};

}

#endif

