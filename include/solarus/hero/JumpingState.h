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
#ifndef SOLARUS_HERO_JUMPING_STATE_H
#define SOLARUS_HERO_JUMPING_STATE_H

#include "solarus/core/Common.h"
#include "solarus/hero/HeroState.h"
#include <memory>

namespace Solarus {

class JumpMovement;

/**
 * \brief The state "Jumping" of the hero.
 */
class Hero::JumpingState: public HeroState {

  public:

    JumpingState(
        Hero& hero,
        int direction8,
        int distance,
        bool ignore_obstacles,
        bool with_sound
    );

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;
    void set_map(Map& map) override;
    void update() override;
    void set_suspended(bool suspended) override;
    void notify_layer_changed() override;
    int get_wanted_movement_direction8() const override;
    bool can_start_gameover_sequence() const override;
    bool is_touching_ground() const override;
    bool is_stairs_obstacle(Stairs& stairs) override;
    bool is_sensor_obstacle(Sensor& sensor) override;
    bool is_separator_obstacle(Separator& separator) override;
    bool can_avoid_deep_water() const override;
    bool can_avoid_hole() const override;
    bool can_avoid_ice() const override;
    bool can_avoid_lava() const override;
    bool can_avoid_prickle() const override;
    bool can_avoid_teletransporter() const override;
    bool can_avoid_stream(const Stream& stream) const override;
    bool can_avoid_sensor() const override;
    bool can_avoid_switch() const override;
    bool get_can_be_hurt(Entity* attacker) override;
    std::shared_ptr<CarriedObject> get_carried_object() const override;
    CarriedObject::Behavior get_previous_carried_object_behavior() const override;

  private:

    std::shared_ptr<JumpMovement>
        movement;                 /**< the movement applied to the hero */
    int direction8;               /**< direction of the jump (0 to 7) */
    bool with_sound;              /**< indicates that a jump sound is played */
    std::shared_ptr<CarriedObject>
        carried_object;             /**< an item carried by the hero while making
                                   * this jump, or nullptr */

};

}

#endif

