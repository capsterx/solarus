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
#ifndef SOLARUS_HERO_SWIMMING_STATE_H
#define SOLARUS_HERO_SWIMMING_STATE_H

#include "solarus/core/Common.h"
#include "solarus/hero/PlayerMovementState.h"
#include <cstdint>

namespace Solarus {

/**
 * \brief The state "Swimming" of the hero.
 */
class Hero::SwimmingState: public Hero::PlayerMovementState {

  public:

    explicit SwimmingState(Hero& hero);

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;
    void update() override;
    void set_suspended(bool suspended) override;

    void set_animation_stopped() override;
    void set_animation_walking() override;

    void notify_action_command_pressed() override;
    void notify_attack_command_pressed() override;

    bool is_stairs_obstacle(Stairs& stairs) override;
    bool get_can_pick_treasure(EquipmentItem& item) const override;
    bool get_can_interact_with_npc(Npc& npc) const override;

  private:

    int get_slow_swimming_speed() const;
    int get_fast_swimming_speed() const;
    void try_swim_faster();

    bool fast_swimming;            /**< indicates that the hero is currently swimming faster */
    uint32_t end_fast_swim_date;   /**< date when the fast swimming stops */

};

}

#endif

