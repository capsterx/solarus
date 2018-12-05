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
#include "solarus/entities/TraversableInfo.h"
#include "solarus/hero/HeroState.h"
#include <set>

namespace Solarus {

class InputEvent;
class PlayerMovement;

/**
 * \brief The state "custom" of the hero.
 *
 * Delegates everything to a Lua object of type state.
 */
class CustomState: public HeroState {

  public:

    CustomState(LuaContext& lua_context, const std::string& description);
    const std::string& get_lua_type_name() const override;

    LuaContext& get_lua_context();

    void start(const State* previous_state) override;
    void stop(const State* next_state) override;

    void set_map(Map& map) override;
    void notify_map_started(
        Map& map, const std::shared_ptr<Destination>& destination) override;
    void notify_map_opening_transition_finished(
        Map& map, const std::shared_ptr<Destination>& destination) override;
    void notify_map_finished() override;
    void update() override;
    void set_suspended(bool suspended) override;
    bool notify_input(const InputEvent& event) override;
    void notify_command_pressed(GameCommand command) override;
    void notify_command_released(GameCommand command) override;
    void draw_on_map() override;

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

    void set_can_traverse_entities(bool traversable);
    void set_can_traverse_entities(const ScopedLuaRef& traversable_test_ref);
    void reset_can_traverse_entities();
    void set_can_traverse_entities(EntityType type, bool traversable);
    void set_can_traverse_entities(
        EntityType type,
        const ScopedLuaRef& traversable_test_ref
    );
    void reset_can_traverse_entities(EntityType type);

    bool is_hero_obstacle(Hero& hero) override;
    bool is_block_obstacle(Block& block) override;
    bool is_teletransporter_obstacle(Teletransporter& teletransporter) override;
    bool is_stream_obstacle(Stream& stream) override;
    bool is_stairs_obstacle(Stairs& stairs) override;
    bool is_sensor_obstacle(Sensor& sensor) override;
    bool is_switch_obstacle(Switch& sw) override;
    bool is_raised_block_obstacle(CrystalBlock& raised_block) override;
    bool is_crystal_obstacle(Crystal& crystal) override;
    bool is_npc_obstacle(Npc& npc) override;
    bool is_door_obstacle(Door& block) override;
    bool is_enemy_obstacle(Enemy& enemy) override;
    bool is_jumper_obstacle(Jumper& jumper, const Rectangle& candidate_position) override;
    bool is_destructible_obstacle(Destructible& destructible) override;
    bool is_separator_obstacle(Separator& separator) override;

    bool get_can_traverse_ground(Ground ground) const;
    void set_can_traverse_ground(Ground ground, bool traversable);

    bool is_traversable_obstacle() const override;
    bool is_wall_obstacle() const override;
    bool is_low_wall_obstacle() const override;
    bool is_grass_obstacle() const override;
    bool is_shallow_water_obstacle() const override;
    bool is_deep_water_obstacle() const override;
    bool is_hole_obstacle() const override;
    bool is_ice_obstacle() const override;
    bool is_lava_obstacle() const override;
    bool is_prickle_obstacle() const override;
    bool is_ladder_obstacle() const override;

    bool is_touching_ground() const override;
    void set_touching_ground(bool touching_ground);
    bool is_affected_by_ground(Ground ground) const;
    void set_affected_by_ground(Ground ground, bool affected);
    bool get_can_come_from_bad_ground() const override;
    void set_can_come_from_bad_ground(bool can_come_from_bad_ground);
    bool can_avoid_deep_water() const override;
    bool can_avoid_hole() const override;
    bool can_avoid_ice() const override;
    bool can_avoid_lava() const override;
    bool can_avoid_prickle() const override;
    bool is_affected_by_shallow_water() const override;
    bool is_affected_by_grass() const override;
    bool is_affected_by_ladder() const override;

    bool get_can_be_hurt(Entity* attacker) override;
    void set_can_be_hurt(bool can_be_hurt);
    void set_can_be_hurt(const ScopedLuaRef& can_be_hurt_callback);
    bool get_can_start_sword() const override;
    void set_can_start_sword(bool can_start_sword);
    bool is_cutting_with_sword(Entity& entity) override;
    bool get_can_cut(Entity* entity);
    void set_can_cut(bool can_cut);
    void set_can_cut(const ScopedLuaRef& can_cut_callback);
    bool get_can_use_shield() const override;
    void set_can_use_shield(bool can_use_shield);
    bool get_can_start_item(EquipmentItem& item) const override;
    bool get_can_start_item(const std::string& item_id) const;
    void set_can_start_item(const std::string& item_id, bool can_start_item);
    bool get_can_interact() const;
    void set_can_interact(bool can_interact);
    bool get_can_grab() const;
    void set_can_grab(bool can_grab);
    bool get_can_push() const;
    void set_can_push(bool can_push);
    uint32_t get_pushing_delay() const;
    void set_pushing_delay(uint32_t pushing_delay);
    bool get_can_pick_treasure() const;
    bool get_can_pick_treasure(EquipmentItem& item) const override;
    void set_can_pick_treasure(bool can_pick_treasure);
    bool get_can_take_stairs() const override;
    void set_can_take_stairs(bool can_take_stairs);
    bool get_can_take_jumper() const override;
    void set_can_take_jumper(bool can_take_jumper);
    uint32_t get_jumper_delay() const;
    void set_jumper_delay(uint32_t jumper_delay);
    void notify_jumper_activated(Jumper& jumper) override;
    CarriedObject::Behavior get_previous_carried_object_behavior() const override;
    void set_previous_carried_object_behavior(CarriedObject::Behavior behavior);
    std::shared_ptr<CarriedObject> get_carried_object() const override;
    void notify_position_changed() override;
    void notify_layer_changed() override;
    void notify_ground_below_changed() override;
    void notify_obstacle_reached() override;
    void notify_movement_started() override;
    void notify_movement_finished() override;
    void notify_movement_changed() override;
    void notify_attacked_enemy(
        EnemyAttack attack,
        Enemy& victim,
        Sprite* victim_sprite,
        const EnemyReaction::Reaction& result,
        bool killed) override;

  private:

    const TraversableInfo& get_can_traverse_entity_info(EntityType type);

    void start_player_movement();
    void update_pushing();
    void update_jumper();
    void cancel_jumper();

    LuaContext& lua_context;               /**< The Lua context. */
    std::string description;               /**< Description of this state or an empty string. */
    bool visible;                          /**< Whether the entity is visible during this state. */
    ScopedLuaRef draw_override;            /**< Optional Lua function that draws the entity during this state. */
    bool can_control_direction;            /**< Whether the player controls the sprites direction. */
    bool can_control_movement;             /**< Whether the player controls the hero's movement. */
    std::shared_ptr<PlayerMovement>
        player_movement;                   /**< The movement, if controlled by the player. */
    bool touching_ground;                  /**< Whether the entity is in contact with the ground. */
    std::set<Ground> ignored_grounds;      /**< Grounds whose effect does not affect this state. */
    bool can_come_from_bad_ground;         /**< Whether solid ground position is considered as
                                            * a place where to come back from bad grounds. */
    bool can_be_hurt;                      /**< Whether the entity be hurt in this state. */
    ScopedLuaRef can_be_hurt_callback;     /**< Boolean function deciding if the entity can be hurt. */
    bool can_start_sword;                  /**< Whether the sword can be used in this state. */
    bool can_cut;                          /**< Whether the sword can cut destructibles in this state. */
    ScopedLuaRef can_cut_callback;         /**< Boolean function deciding if destructibles can be cut. */
    bool can_use_shield;                   /**< Whether the shield can be used in this state. */
    bool can_start_item;                   /**< Whether items in general can be used in this state. */
    std::map<std::string, bool>
        can_start_items;                   /**< Whether specific items can be used in this state. */
    bool can_interact;                     /**< Whether interacting with the facing entity
                                            * is allowed in this state. */
    bool can_grab;                         /**< Whether grabbing is allowed in this state. */
    bool can_push;                         /**< Whether pushing is allowed in this state. */
    uint32_t pushing_delay;                /**< Delay before pushing. */
    int pushing_direction4;                /**< Direction where trying to
                                            * push an obstacle: 0 to 3 or -1 */
    uint32_t start_pushing_date;           /**< Date when state pushing should start. */
    bool can_pick_treasure;                /**< Whether treasures can be picked in this state. */
    bool can_take_stairs;                  /**< Whether stairs can be used in this state. */
    bool can_take_jumper;                  /**< Whether jumpers can be used in this state. */
    std::shared_ptr<Jumper>
        current_jumper;                    /**< The jumper about to be triggered or nullptr. */
    uint32_t jumper_start_date;            /**< Date when to trigger the jumper
                                            * (in case there is a delay). */
    uint32_t jumper_delay;                 /**< Delay before a jumper activates. */
    CarriedObject::Behavior
        previous_carried_object_behavior;  /**< What happens during this state to an object that
                                            * was carried in the previous state. */    
    std::shared_ptr<CarriedObject>
        carried_object;                    /**< Object carried by the entity if any. */
    TraversableInfo
        can_traverse_entities_general;     /**< Whether the entity can traverse other entities by default. */
    std::map<EntityType, TraversableInfo>
        can_traverse_entities_type;        /**< Whether the entity can traverse entities of a type. */
    std::map<Ground, bool>
        can_traverse_grounds;              /**< Whether the entity can traverse each kind of ground. */
};

}

#endif

