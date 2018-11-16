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
#ifndef SOLARUS_HERO_HOOKSHOT_STATE_H
#define SOLARUS_HERO_HOOKSHOT_STATE_H

#include "solarus/core/Common.h"
#include "solarus/hero/HeroState.h"
#include <memory>

namespace Solarus {

class Hookshot;

/**
 * \brief The state "hookshot" of the hero.
 */
class Hero::HookshotState: public HeroState {

  public:

    explicit HookshotState(Hero& hero);

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;

    bool is_touching_ground() const override;
    bool can_avoid_deep_water() const override;
    bool can_avoid_hole() const override;
    bool can_avoid_ice() const override;
    bool can_avoid_lava() const override;
    bool can_avoid_prickle() const override;
    bool can_avoid_teletransporter() const override;
    bool can_avoid_stream(const Stream& stream) const override;
    bool is_stairs_obstacle(Stairs& stairs) override;
    bool is_sensor_obstacle(Sensor& sensor) override;
    bool is_jumper_obstacle(Jumper& jumper, const Rectangle& candidate_position) override;
    bool can_avoid_switch() const override;
    bool get_can_be_hurt(Entity* attacker) override;
    bool get_can_pick_treasure(EquipmentItem& item) const override;
    void notify_obstacle_reached() override;

  private:

    void finish_movement();

    std::shared_ptr<Hookshot> hookshot;     /**< the hookshot thrown by the hero */
};

}

#endif

