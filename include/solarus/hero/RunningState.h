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
#ifndef SOLARUS_HERO_RUNNING_STATE_H
#define SOLARUS_HERO_RUNNING_STATE_H

#include "solarus/core/Common.h"
#include "solarus/hero/HeroState.h"
#include <cstdint>

namespace Solarus {

/**
 * \brief The state "Running" of the hero.
 */
class Hero::RunningState: public HeroState {

  public:

    RunningState(Hero& hero, GameCommand command);

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;
    void update() override;
    void set_suspended(bool suspended) override;
    bool is_pressing_running_key() const;
    void notify_direction_command_pressed(int direction4) override;
    void notify_obstacle_reached() override;
    int get_wanted_movement_direction8() const override;

    bool get_can_take_jumper() const override;
    void notify_jumper_activated(Jumper& jumper) override;
    bool get_can_take_stairs() const override;
    bool get_can_be_hurt(Entity* attacker) override;
    bool get_can_pick_treasure(EquipmentItem& item) const override;
    bool can_sword_hit_crystal() const override;
    bool can_start_gameover_sequence() const override;
    bool is_touching_ground() const override;
    bool can_avoid_deep_water() const override;
    bool can_avoid_hole() const override;
    bool can_avoid_lava() const override;
    bool can_avoid_prickle() const override;
    bool can_avoid_teletransporter() const override;
    bool can_avoid_stream(const Stream& stream) const override;
    bool can_persist_on_stream(const Stream& stream) const override;
    bool is_sensor_obstacle(Sensor& sensor) override;
    bool is_cutting_with_sword(Entity& entity) override;
    int get_sword_damage_factor() const override;

  private:

    bool is_bouncing() const;

    int phase;                      /**< current phase of the run */
    uint32_t next_phase_date;       /**< date of the next phase */
    uint32_t next_sound_date;       /**< date of the next time a sound is played during the run */
    GameCommand command;            /**< the command pressed to make the hero run */

};

}

#endif

