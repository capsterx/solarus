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
#ifndef SOLARUS_HERO_PULLING_STATE_H
#define SOLARUS_HERO_PULLING_STATE_H

#include "solarus/core/Common.h"
#include "solarus/hero/HeroState.h"
#include <memory>

namespace Solarus {

class PathMovement;

/**
 * \brief The state "Pulling" of the hero.
 */
class Hero::PullingState: public HeroState {

  public:

    explicit PullingState(Hero& hero);

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;
    void update() override;
    void notify_grabbed_entity_collision() override;
    void notify_movement_finished() override;
    void notify_position_changed() override;
    void notify_obstacle_reached() override;
    bool is_grabbing_or_pulling() const override;
    bool is_moving_grabbed_entity() const override;
    bool is_shallow_water_obstacle() const override;
    bool is_deep_water_obstacle() const override;
    bool is_hole_obstacle() const override;
    bool is_lava_obstacle() const override;
    bool is_prickle_obstacle() const override;
    bool is_stream_obstacle(Stream& stream) override;
    bool is_separator_obstacle(Separator& separator) override;

    bool get_can_be_hurt(Entity* attacker) override;
    bool get_can_pick_treasure(EquipmentItem& item) const override;

  private:

    void stop_moving_pulled_entity();

    Entity* pulled_entity;             /**< The entity the hero is pulling (or nullptr). */
    std::shared_ptr<PathMovement>
        pulling_movement;              /**< The movement created by this state.
                                        * The movement of the hero is also this object,
                                        * unless a script decided to change it. */

};

}

#endif

