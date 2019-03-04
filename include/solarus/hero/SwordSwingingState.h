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
#ifndef SOLARUS_HERO_SWORD_SWINGING_STATE_H
#define SOLARUS_HERO_SWORD_SWINGING_STATE_H

#include "solarus/hero/HeroState.h"

namespace Solarus {

/**
 * \brief The state "sword swinging" of the hero.
 */
class Hero::SwordSwingingState: public HeroState {

  public:

    explicit SwordSwingingState(Hero& hero);

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;
    void update() override;
    bool get_can_start_sword() const override;
    bool get_can_be_hurt(Entity* attacker) override;
    bool get_can_pick_treasure(EquipmentItem& item) const override;
    bool get_can_use_shield() const override;
    bool can_sword_hit_crystal() const override;
    bool is_cutting_with_sword(Entity& entity) override;
    bool is_teletransporter_obstacle(Teletransporter& teletransporter) override;
    void notify_obstacle_reached() override;
    void notify_attacked_enemy(
        EnemyAttack attack,
        Enemy& victim,
        Sprite* victim_sprite,
        const EnemyReaction::Reaction& result,
        bool killed
    ) override;

  private:

    bool attacked;               /**< indicates that at least one enemy was attacked */
    bool sword_finished;         /**< indicates that the sword animation is finished */

};

}

#endif

