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
#ifndef SOLARUS_ENTITY_STATE_H
#define SOLARUS_ENTITY_STATE_H

#include "solarus/core/Common.h"
#include "solarus/entities/CarriedObject.h"
#include "solarus/entities/Hero.h"
#include "solarus/lua/ExportableToLua.h"
#include <cstdint>
#include <memory>
#include <string>

namespace Solarus {

/**
 * \brief Abstract base class for a state of an entity.
 *
 * This class contains all entity-related functions that depend on its state
 * and provide a default implementation for them.
 * Most of them are almost empty here because they depend on the state.
 * Redefine for each state the functions that you need to implement or change.
 */
class Entity::State : public ExportableToLua {

  public:

    // creation and destruction
    virtual ~State();
    const std::string& get_name() const;

    template<typename T>
    T& get_entity();
    template<typename T>
    const T& get_entity() const;
    void set_entity(Entity& entity);
    bool has_entity() const;

    bool is_current_state() const;
    bool is_stopping() const;
    virtual void start(const State* previous_state);
    virtual void stop(const State* next_state);

    // game loop
    virtual void update();
    virtual void draw_on_map();
    bool is_suspended() const;
    virtual void set_suspended(bool suspended);
    uint32_t get_when_suspended() const;
    virtual bool notify_input(const InputEvent& event);
    virtual void notify_command_pressed(GameCommand command);
    virtual void notify_command_released(GameCommand command);
    virtual void notify_action_command_pressed();
    virtual void notify_action_command_released();
    virtual void notify_attack_command_pressed();
    virtual void notify_attack_command_released();
    virtual void notify_direction_command_pressed(int direction4);
    virtual void notify_direction_command_released(int direction4);
    virtual void notify_item_command_pressed(int slot);
    virtual void notify_item_command_released(int slot);

    // game
    virtual void set_map(Map& map);
    virtual void notify_map_started(
        Map& map, const std::shared_ptr<Destination>& destination);
    virtual void notify_map_opening_transition_finished(
        Map& map, const std::shared_ptr<Destination>& destination);
    virtual void notify_map_finished();
    virtual bool can_start_gameover_sequence() const;

    // sprites
    virtual bool is_visible() const;
    virtual bool is_direction_locked() const;

    // movement
    virtual bool get_can_control_movement() const;
    virtual int get_wanted_movement_direction8() const;
    virtual void notify_walking_speed_changed();
    virtual void notify_position_changed();
    virtual void notify_layer_changed();
    virtual void notify_obstacle_reached();
    virtual void notify_movement_started();
    virtual void notify_movement_changed();
    virtual void notify_movement_finished();

    // ground
    virtual bool can_avoid_deep_water() const;
    virtual bool can_avoid_hole() const;
    virtual bool can_avoid_ice() const;
    virtual bool can_avoid_lava() const;
    virtual bool can_avoid_prickle() const;
    virtual bool is_affected_by_shallow_water() const;
    virtual bool is_affected_by_grass() const;
    virtual bool is_affected_by_ladder() const;
    virtual bool is_touching_ground() const;
    virtual bool get_can_come_from_bad_ground() const;
    virtual void notify_ground_below_changed();

    // obstacles and collisions
    virtual bool are_collisions_ignored() const;
    virtual bool is_traversable_obstacle() const;
    virtual bool is_wall_obstacle() const;
    virtual bool is_low_wall_obstacle() const;
    virtual bool is_grass_obstacle() const;
    virtual bool is_shallow_water_obstacle() const;
    virtual bool is_deep_water_obstacle() const;
    virtual bool is_hole_obstacle() const;
    virtual bool is_ice_obstacle() const;
    virtual bool is_lava_obstacle() const;
    virtual bool is_prickle_obstacle() const;
    virtual bool is_ladder_obstacle() const;
    virtual bool is_hero_obstacle(Hero& hero);
    virtual bool is_block_obstacle(Block& block);
    virtual bool is_teletransporter_obstacle(Teletransporter& teletransporter);
    virtual bool can_avoid_teletransporter() const;
    virtual bool is_teletransporter_delayed() const;
    virtual bool is_stream_obstacle(Stream& stream);
    virtual bool can_avoid_stream(const Stream& stream) const;
    virtual bool can_persist_on_stream(const Stream& stream) const;
    virtual bool is_stairs_obstacle(Stairs& stairs);
    virtual bool is_sensor_obstacle(Sensor& sensor);
    virtual bool is_switch_obstacle(Switch& sw);
    virtual bool is_raised_block_obstacle(CrystalBlock& raised_block);
    virtual bool is_crystal_obstacle(Crystal& crystal);
    virtual bool is_npc_obstacle(Npc& npc);
    virtual bool is_door_obstacle(Door& block);
    virtual bool is_enemy_obstacle(Enemy& enemy);
    virtual bool is_jumper_obstacle(Jumper& jumper, const Rectangle& candidate_position);
    virtual bool is_destructible_obstacle(Destructible& destructible);
    virtual bool is_separator_obstacle(Separator& separator);
    virtual bool get_can_start_sword() const;
    virtual bool get_can_pick_treasure(EquipmentItem& item) const;
    virtual bool get_can_use_shield() const;
    virtual bool get_can_start_item(EquipmentItem& item) const;
    virtual bool get_can_take_stairs() const;
    virtual bool can_sword_hit_crystal() const;
    virtual bool get_can_take_jumper() const;
    virtual void notify_jumper_activated(Jumper& jumper);
    virtual bool can_avoid_sensor() const;
    virtual bool can_avoid_explosion() const;
    virtual bool can_avoid_switch() const;

    // enemies
    virtual void notify_attacked_enemy(
        EnemyAttack attack,
        Enemy& victim,
        Sprite* victim_sprite,
        const EnemyReaction::Reaction& result,
        bool killed);
    virtual int get_sword_damage_factor() const;
    virtual bool get_can_be_hurt(Entity* attacker);

    // state specific
    virtual bool is_free() const;
    virtual bool is_using_item() const;
    virtual EquipmentItemUsage& get_item_being_used();
    virtual bool is_brandishing_treasure() const;
    virtual bool is_grabbing_or_pulling() const;
    virtual bool is_moving_grabbed_entity() const;
    virtual void notify_grabbed_entity_collision();
    virtual bool is_cutting_with_sword(Entity& entity);
    bool is_carrying_item() const;
    virtual std::shared_ptr<CarriedObject> get_carried_object() const;
    virtual CarriedObject::Behavior get_previous_carried_object_behavior() const;

  protected:

    explicit State(const std::string& state_name);

    // access to various game objects
    LuaContext& get_lua_context();
    Entities& get_entities();
    Game& get_game();
    const Game& get_game() const;
    Map& get_map();
    Equipment& get_equipment();
    const Equipment& get_equipment() const;
    CommandsEffects& get_commands_effects();
    GameCommands& get_commands();
    const GameCommands& get_commands() const;
    virtual Entity& get_entity();
    virtual const Entity& get_entity() const;

  private:

    EntityPtr entity;         /**< The entity controlled by this state. */
    bool suspended;           /**< Whether this state is suspended. */
    uint32_t when_suspended;  /**< When this state was suspended. */
    std::shared_ptr<Map> map; /**< The current map (it may change during this state). */
    const std::string name;   /**< Name describing this state. */
    bool stopping;            /**< Indicates that this state is being stopped. */

};

/**
 * \brief Returns the entity of this state cast to an entity type.
 * \return The entity.
 */
template<typename T>
T& Entity::State::get_entity() {
  return static_cast<T&>(get_entity());
}

/**
 * \brief Returns the entity of this state cast to an entity type.
 * \return The entity.
 */
template<typename T>
const T& Entity::State::get_entity() const {
  return static_cast<const T&>(get_entity());
}

}

#endif

