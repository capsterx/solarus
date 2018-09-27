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
#include "solarus/entities/Ground.h"
#include "solarus/hero/HeroState.h"
#include <set>

namespace Solarus {

class PlayerMovement;

/**
 * \brief The state "custom" of the hero.
 *
 * Delegates everything to a Lua object of type state.
 */
class CustomState: public HeroState {

  public:

    explicit CustomState(const std::string& description);
    const std::string& get_lua_type_name() const override;

    const std::string& get_description() const;
    void set_description(const std::string& description);
    bool is_visible() const override;
    void set_visible(bool visible);
    ScopedLuaRef get_draw_override() const;
    void set_draw_override(const ScopedLuaRef& draw_override);

    bool get_can_control_direction() const;
    void set_can_control_direction(bool can_control_direction);
    bool is_direction_locked() const override;
    int get_wanted_movement_direction8() const override;

    void set_can_control_movement(bool can_control_movement);
    bool get_can_control_movement() const override;

    bool is_affected_by_ground(Ground ground) const;
    void set_affected_by_ground(Ground ground, bool affected);
    bool can_avoid_deep_water() const override;
    bool can_avoid_hole() const override;
    bool can_avoid_ice() const override;
    bool can_avoid_lava() const override;
    bool can_avoid_prickle() const override;

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;

    void update() override;
    void draw_on_map() override;

  private:

    void start_player_movement();

    std::string description;               /**< Description of this state or an empty string. */
    bool visible;                          /**< Whether the entity is visible during this state. */
    ScopedLuaRef draw_override;            /**< Optional Lua function that draws the entity during this state. */
    bool can_control_direction;            /**< Whether the player controls the sprites direction. */
    bool can_control_movement;             /**< Whether the player controls the hero's movement. */
    std::shared_ptr<PlayerMovement>
        player_movement;                   /**< The movement, if controlled by the player. */
    std::set<Ground> ignored_grounds;      /**< Grounds whose effect does not affect this state. */
};

}

#endif

