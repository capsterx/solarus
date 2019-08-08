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
#include "solarus/core/CurrentQuest.h"
#include "solarus/core/Game.h"
#include "solarus/core/Map.h"
#include "solarus/entities/EntityTypeInfo.h"
#include "solarus/entities/GroundInfo.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"
#include "solarus/hero/CustomState.h"

namespace Solarus {

/**
 * Name of the Lua table representing the state module.
 */
const std::string LuaContext::state_module_name = "sol.state";

/**
 * \brief Initializes the state features provided to Lua.
 */
void LuaContext::register_state_module() {

  if (!CurrentQuest::is_format_at_least({ 1, 6 })) {
    return;
  }

  // Functions of sol.state.
  const std::vector<luaL_Reg> functions = {
      { "create", state_api_create },
  };

  // Methods of the state type.
  const std::vector<luaL_Reg> methods = {
    { "get_description", state_api_get_description },
    { "set_description", state_api_set_description },
    { "get_entity", state_api_get_entity },
    { "get_map", state_api_get_map },
    { "get_game", state_api_get_game },
    { "is_started", state_api_is_started },
    { "is_visible", state_api_is_visible },
    { "set_visible", state_api_set_visible },
    { "get_draw_override", state_api_get_draw_override },
    { "set_draw_override", state_api_set_draw_override },
    { "get_can_control_direction", state_api_get_can_control_direction },
    { "set_can_control_direction", state_api_set_can_control_direction },
    { "get_can_control_movement", state_api_get_can_control_movement },
    { "set_can_control_movement", state_api_set_can_control_movement },
    { "set_can_traverse", state_api_set_can_traverse },
    { "get_can_traverse_ground", state_api_get_can_traverse_ground },
    { "set_can_traverse_ground", state_api_set_can_traverse_ground },
    { "is_gravity_enabled", state_api_is_gravity_enabled },
    { "set_gravity_enabled", state_api_set_gravity_enabled },
    { "is_affected_by_ground", state_api_is_affected_by_ground },
    { "set_affected_by_ground", state_api_set_affected_by_ground },
    { "get_can_come_from_bad_ground", state_api_get_can_come_from_bad_ground },
    { "set_can_come_from_bad_ground", state_api_set_can_come_from_bad_ground },
    { "get_can_be_hurt", state_api_get_can_be_hurt },
    { "set_can_be_hurt", state_api_set_can_be_hurt },
    { "get_can_use_sword", state_api_get_can_use_sword },
    { "set_can_use_sword", state_api_set_can_use_sword },
    { "get_can_cut", state_api_get_can_cut },
    { "set_can_cut", state_api_set_can_cut },
    { "get_can_use_shield", state_api_get_can_use_shield },
    { "set_can_use_shield", state_api_set_can_use_shield },
    { "get_can_use_item", state_api_get_can_use_item },
    { "set_can_use_item", state_api_set_can_use_item },
    { "get_can_interact", state_api_get_can_interact },
    { "set_can_interact", state_api_set_can_interact },
    { "get_can_grab", state_api_get_can_grab },
    { "set_can_grab", state_api_set_can_grab },
    { "get_can_push", state_api_get_can_push },
    { "set_can_push", state_api_set_can_push },
    { "get_pushing_delay", state_api_get_pushing_delay },
    { "set_pushing_delay", state_api_set_pushing_delay },
    { "get_can_pick_treasure", state_api_get_can_pick_treasure },
    { "set_can_pick_treasure", state_api_set_can_pick_treasure },
    { "get_can_use_teletransporter", state_api_get_can_use_teletransporter },
    { "set_can_use_teletransporter", state_api_set_can_use_teletransporter },
    { "get_can_use_switch", state_api_get_can_use_switch },
    { "set_can_use_switch", state_api_set_can_use_switch },
    { "get_can_use_stream", state_api_get_can_use_stream },
    { "set_can_use_stream", state_api_set_can_use_stream },
    { "get_can_use_stairs", state_api_get_can_use_stairs },
    { "set_can_use_stairs", state_api_set_can_use_stairs },
    { "get_can_use_jumper", state_api_get_can_use_jumper },
    { "set_can_use_jumper", state_api_set_can_use_jumper },
    { "get_jumper_delay", state_api_get_jumper_delay },
    { "set_jumper_delay", state_api_set_jumper_delay },
    { "get_carried_object_action", state_api_get_carried_object_action },
    { "set_carried_object_action", state_api_set_carried_object_action },
  };

  const std::vector<luaL_Reg> metamethods = {
      { "__gc", userdata_meta_gc },
      { "__newindex", userdata_meta_newindex_as_table },
      { "__index", userdata_meta_index_as_table }
  };

  register_type(state_module_name, functions, methods, metamethods);
}

/**
 * \brief Returns whether a value is a userdata of type state.
 * \param l A Lua context.
 * \param index An index in the stack.
 * \return \c true if the value at this index is a state.
 */
bool LuaContext::is_state(lua_State* l, int index) {
  return is_userdata(l, index, state_module_name);
}

/**
 * \brief Checks that the userdata at the specified index of the stack is a
 * state and returns it.
 * \param l a Lua context
 * \param index An index in the stack.
 * \return The state.
 */
std::shared_ptr<CustomState> LuaContext::check_state(lua_State* l, int index) {
  return std::static_pointer_cast<CustomState>(check_userdata(
      l, index, state_module_name
  ));
}

/**
 * \brief Pushes a state userdata onto the stack.
 * \param l A Lua context.
 * \param state A state.
 */
void LuaContext::push_state(lua_State* l, CustomState& state) {
  push_userdata(l, state);
}

/**
 * \brief Calls the draw override function of a custom state.
 * \param draw_override The draw override function.
 * \param state The state to draw.
 * \param camera The camera where to draw the entity.
 */
void LuaContext::do_state_draw_override_function(
    const ScopedLuaRef& draw_override,
    CustomState& state,
    Camera& camera
) {
  push_ref(current_l, draw_override);
  push_state(current_l, state);
  push_camera(current_l, camera);
  call_function(2, 0, "state draw override");
}

/**
 * \brief Calls the can-be-hurt function of a custom state.
 * \param can_be_hurt The function to call.
 * \param state The state to test.
 * \param attacker Source of the attack or nullptr.
 */
bool LuaContext::do_state_can_be_hurt_function(
    const ScopedLuaRef& can_be_hurt,
    CustomState& state,
    Entity* attacker) {
  push_ref(current_l, can_be_hurt);
  push_state(current_l, state);
  if (attacker == nullptr) {
    lua_pushnil(current_l);
  } else {
    push_entity(current_l, *attacker);
  }
  if (!call_function(2, 1, "state can_be_hurt callback")) {
    return true;
  }
  return LuaTools::opt_boolean(current_l, -1, "true");
}

/**
 * \brief Calls the can-cut function of a custom state.
 * \param can_cut The function to call.
 * \param state The state to test.
 * \param entity The entity to test or nullptr.
 */
bool LuaContext::do_state_can_cut_function(
    const ScopedLuaRef& can_cut,
    CustomState& state,
    Entity* entity) {
  push_ref(current_l, can_cut);
  push_state(current_l, state);
  if (entity == nullptr) {
    lua_pushnil(current_l);
  } else {
    push_entity(current_l, *entity);
  }
  if (!call_function(2, 1, "state can_cut callback")) {
    return true;
  }
  return LuaTools::opt_boolean(current_l, -1, "true");
}

/**
 * \brief Implementation of sol.state.create().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_create(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const std::string& description = LuaTools::opt_string(l, 1, "");

    std::shared_ptr<CustomState> state = std::make_shared<CustomState>(get(), description);

    push_state(l, *state);
    return 1;
  });
}

/**
 * \brief Implementation of state:get_description().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_description(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    const std::string& description = state.get_description();
    if (description.empty()) {
      lua_pushnil(l);
    }
    else {
      push_string(l, description);
    }
    return 1;
  });
}

/**
 * \brief Implementation of state:set_description().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_description(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    std::string description;
    if (lua_isstring(l, 2)) {
      description = LuaTools::check_string(l, 2);
    }
    else if (!lua_isnil(l, 2)) {
      LuaTools::type_error(l, 2, "string or nil");
    }

    state.set_description(description);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_entity().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_entity(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    if (!state.has_entity()) {
      lua_pushnil(l);
    }
    else {
      Entity& entity = state.get_entity();
      push_entity(l, entity);
    }
    return 1;
  });
}

/**
 * \brief Implementation of state:get_map().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_map(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    if (!state.has_entity()) {
      lua_pushnil(l);
    }
    else {
      Entity& entity = state.get_entity();
      if (!entity.is_on_map()) {
        lua_pushnil(l);
      }
      else {
        push_map(l, entity.get_map());
      }
    }
    return 1;
  });
}

/**
 * \brief Implementation of state:get_game().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_game(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    if (!state.has_entity()) {
      lua_pushnil(l);
    }
    else {
      Entity& entity = state.get_entity();
      if (!entity.is_on_map()) {
        lua_pushnil(l);
      }
      else {
        Map& map = entity.get_map();
        if (!map.is_game_running()) {
          lua_pushnil(l);
        }
        else {
          push_game(l, map.get_game().get_savegame());
        }
      }
    }
    return 1;
  });
}

/**
 * \brief Implementation of state:is_started().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_is_started(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.is_current_state());
    return 1;
  });
}

/**
 * \brief Implementation of state:is_visible().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_is_visible(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.is_visible());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_visible().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_visible(lua_State* l) {

  return LuaTools::exception_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool visible = LuaTools::opt_boolean(l, 2, true);

    state.set_visible(visible);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_control_direction().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_control_direction(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_control_direction());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_control_direction().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_control_direction(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_control_direction = LuaTools::check_boolean(l, 2);

    state.set_can_control_direction(can_control_direction);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_control_movement().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_control_movement(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_control_movement());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_control_movement().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_control_movement(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_control_movement = LuaTools::check_boolean(l, 2);

    state.set_can_control_movement(can_control_movement);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_draw_override().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_draw_override(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    ScopedLuaRef draw_override = state.get_draw_override();
    if (draw_override.is_empty()) {
      lua_pushnil(l);
    }
    else {
      push_ref(l, draw_override);
    }
    return 1;
  });
}

/**
 * \brief Implementation of state:set_draw_override().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_draw_override(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    ScopedLuaRef draw_override;
    if (lua_gettop(l) >= 2) {
      if (lua_isfunction(l, 2)) {
        draw_override = LuaTools::check_function(l, 2);
      }
      else if (!lua_isnil(l, 2)) {
        LuaTools::type_error(l, 2, "function or nil");
      }
    }

    state.set_draw_override(draw_override);

    return 0;
  });
}

/**
 * \brief Implementation of state:set_can_traverse().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_traverse(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    bool type_specific = false;
    EntityType type = EntityType::TILE;
    int index = 2;
    if (lua_isstring(l, index)) {
      ++index;
      type_specific = true;
      type = LuaTools::check_enum<EntityType>(
          l, 2
      );
    }

    if (lua_isnil(l, index)) {
      // Reset the setting.
      if (!type_specific) {
        state.reset_can_traverse_entities();
      }
      else {
        state.reset_can_traverse_entities(type);
      }
    }
    else if (lua_isboolean(l, index)) {
      // Boolean value.
      bool traversable = lua_toboolean(l, index);
      if (!type_specific) {
        state.set_can_traverse_entities(traversable);
      }
      else {
        state.set_can_traverse_entities(type, traversable);
      }
    }
    else if (lua_isfunction(l, index)) {
      // Custom boolean function.
      const ScopedLuaRef& traversable_test_ref = LuaTools::check_function(l, index);
      if (!type_specific) {
        state.set_can_traverse_entities(traversable_test_ref);
      }
      else {
        state.set_can_traverse_entities(type, traversable_test_ref);
      }
    }
    else {
      LuaTools::type_error(l, index, "boolean, function or nil");
    }

    return 0;
  });
}

/**
 * \brief Implementation of state:can_traverse_ground().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_traverse_ground(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);
    Ground ground = LuaTools::check_enum<Ground>(l, 2);

    bool traversable = state.get_can_traverse_ground(ground);

    lua_pushboolean(l, traversable);
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_traverse_ground().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_traverse_ground(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    Ground ground = LuaTools::check_enum<Ground>(l, 2);
    bool traversable = LuaTools::check_boolean(l, 3);

    state.set_can_traverse_ground(ground, traversable);

    return 0;
  });
}

/**
 * \brief Implementation of state:is_gravity_enabled().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_is_gravity_enabled(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.is_touching_ground());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_gravity_enabled().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_gravity_enabled(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool gravity_enabled = LuaTools::check_boolean(l, 2);

    state.set_touching_ground(gravity_enabled);

    return 0;
  });
}

/**
 * \brief Implementation of state:is_affected_by_ground().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_is_affected_by_ground(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);
    Ground ground = LuaTools::check_enum<Ground>(l, 2);

    lua_pushboolean(l, state.is_affected_by_ground(ground));
    return 1;
  });
}

/**
 * \brief Implementation of state:set_affected_by_ground().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_affected_by_ground(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    Ground ground = LuaTools::check_enum<Ground>(l, 2);
    bool affected = LuaTools::opt_boolean(l, 3, true);

    state.set_affected_by_ground(ground, affected);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_come_from_bad_ground().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_come_from_bad_ground(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_come_from_bad_ground());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_come_from_bad_ground().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_come_from_bad_ground(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_come_from_bad_ground = LuaTools::check_boolean(l, 2);

    state.set_can_come_from_bad_ground(can_come_from_bad_ground);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_be_hurt().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_be_hurt(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_be_hurt(nullptr));
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_be_hurt().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_be_hurt(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    if (lua_isboolean(l, 2)) {
      bool can_be_hurt = LuaTools::check_boolean(l, 2);
      state.set_can_be_hurt(can_be_hurt);
    }
    else if (lua_isfunction(l, 2)) {
      // Custom boolean function.
      const ScopedLuaRef& can_be_hurt_callback = LuaTools::check_function(l, 2);
      state.set_can_be_hurt(can_be_hurt_callback);
    }
    else {
      LuaTools::arg_error(l, 2, "boolean or function");
    }

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_sword().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_sword(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_start_sword());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_sword().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_sword(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_use_sword = LuaTools::check_boolean(l, 2);

    state.set_can_start_sword(can_use_sword);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_cut().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_cut(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_cut(nullptr));
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_cut().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_cut(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);

    if (lua_isboolean(l, 2)) {
      bool can_cut = LuaTools::check_boolean(l, 2);
      state.set_can_cut(can_cut);
    }
    else if (lua_isfunction(l, 2)) {
      // Custom boolean function.
      const ScopedLuaRef& can_cut_callback = LuaTools::check_function(l, 2);
      state.set_can_cut(can_cut_callback);
    }
    else {
      LuaTools::arg_error(l, 2, "boolean or function");
    }

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_shield().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_shield(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_use_shield());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_shield().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_shield(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_use_shield = LuaTools::check_boolean(l, 2);

    state.set_can_use_shield(can_use_shield);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_item().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_item(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);
    std::string item_id;

    if (!lua_isnone(l, 2)) {
      item_id = LuaTools::check_string(l, 2);
      if (!CurrentQuest::resource_exists(ResourceType::ITEM, item_id)) {
        LuaTools::arg_error(l, 2, "No such item: '" + item_id + "'");
      }
    }

    lua_pushboolean(l, state.get_can_start_item(item_id));
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_item().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_item(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    std::string item_id;
    int index = 2;
    if (lua_isstring(l, 2)) {
      ++index;
      item_id = LuaTools::check_string(l, 2);
      if (!CurrentQuest::resource_exists(ResourceType::ITEM, item_id)) {
        LuaTools::arg_error(l, 2, "No such item: '" + item_id + "'");
      }
    }
    else if (!lua_isboolean(l, 2)) {
      LuaTools::type_error(l, 2, "string or boolean");
    }
    bool can_use_item = LuaTools::check_boolean(l, index);

    state.set_can_start_item(item_id, can_use_item);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_interact().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_interact(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_interact());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_interact().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_interact(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_interact = LuaTools::check_boolean(l, 2);

    state.set_can_interact(can_interact);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_grab().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_grab(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_grab());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_grab().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_grab(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_grab = LuaTools::check_boolean(l, 2);

    state.set_can_grab(can_grab);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_push().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_push(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_push());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_push().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_push(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_push = LuaTools::check_boolean(l, 2);

    state.set_can_push(can_push);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_pushing_delay().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_pushing_delay(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushinteger(l, state.get_pushing_delay());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_pushing_delay().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_pushing_delay(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    int pushing_delay = LuaTools::check_int(l, 2);

    if (pushing_delay < 0) {
      LuaTools::arg_error(l, 2, "Pushing delay should be positive or zero");
    }
    state.set_pushing_delay(pushing_delay);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_pick_treasure().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_pick_treasure(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_pick_treasure());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_pick_treasure().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_pick_treasure(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_pick_treasure = LuaTools::check_boolean(l, 2);

    state.set_can_pick_treasure(can_pick_treasure);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_teletransporter().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_teletransporter(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_take_teletransporter());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_teletransporter().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_teletransporter(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_take_teletransporter = LuaTools::check_boolean(l, 2);

    state.set_can_take_teletransporter(can_take_teletransporter);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_switch().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_switch(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_take_switch());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_switch().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_switch(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_take_switch = LuaTools::check_boolean(l, 2);

    state.set_can_take_switch(can_take_switch);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_stream().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_stream(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_take_stream());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_stream().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_stream(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_take_stream = LuaTools::check_boolean(l, 2);

    state.set_can_take_stream(can_take_stream);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_stairs().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_stairs(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_take_stairs());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_stairs().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_stairs(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_take_stairs = LuaTools::check_boolean(l, 2);

    state.set_can_take_stairs(can_take_stairs);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_can_use_jumper().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_can_use_jumper(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.get_can_take_jumper());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_can_use_jumper().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_can_use_jumper(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    bool can_take_jumper = LuaTools::check_boolean(l, 2);

    state.set_can_take_jumper(can_take_jumper);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_jumper_delay().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_jumper_delay(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushinteger(l, state.get_jumper_delay());
    return 1;
  });
}

/**
 * \brief Implementation of state:set_jumper_delay().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_jumper_delay(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    int jumper_delay = LuaTools::check_int(l, 2);

    if (jumper_delay < 0) {
      LuaTools::arg_error(l, 2, "Jumper delay should be positive or zero");
    }
    state.set_jumper_delay(jumper_delay);

    return 0;
  });
}

/**
 * \brief Implementation of state:get_carried_object_action().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_get_carried_object_action(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    CarriedObject::Behavior behavior = state.get_previous_carried_object_behavior();
    push_string(l, enum_to_name(behavior));
    return 1;
  });
}

/**
 * \brief Implementation of state:set_carried_object_action().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_set_carried_object_action(lua_State* l) {

  return state_boundary_handle(l, [&] {
    CustomState& state = *check_state(l, 1);
    CarriedObject::Behavior behavior = LuaTools::check_enum<CarriedObject::Behavior>(l, 2);

    state.set_previous_carried_object_behavior(behavior);
    return 0;
  });
}

/**
 * \brief Calls the on_started() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state The custom state that has just started.
 * \param previous_state_name Name of the previous state.
 * \param previous_state The previous state object if it was a custom one.
 */
void LuaContext::state_on_started(
    CustomState& state,
    const std::string& previous_state_name,
    CustomState* previous_state) {

  if (!userdata_has_field(state, "on_started")) {
    return;
  }

  push_state(current_l, state);
  on_started(previous_state_name, previous_state);
  lua_pop(current_l, 1);
}

/**
 * \brief Calls the on_finished() method of a custom state if it is defined.
 *
 * Also stops timers associated to the state.
 *
 * \param state The custom state that has just finished.
 * \param next_state_name Name of the next state.
 * \param next_state The next state object if it is a custom one.
 */
void LuaContext::state_on_finished(
    CustomState& state,
    const std::string& next_state_name,
    CustomState* next_state) {

  run_on_main([this, &state, next_state_name, next_state](lua_State* l) {
    push_state(l, state);
    if (userdata_has_field(state, "on_finished")) {
      on_finished(next_state_name, next_state);
    }
    remove_timers(-1);  // Stop timers associated to this state.
    lua_pop(current_l, 1);
  });
}

/**
 * \brief Calls the on_update() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 */
void LuaContext::state_on_update(CustomState& state) {

  if (!userdata_has_field(state, "on_update")) {
    return;
  }

  run_on_main([this, &state](lua_State* l) {
    push_state(l, state);
    on_update();
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_suspended() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param suspended \c true if the state is suspended.
 */
void LuaContext::state_on_suspended(CustomState& state, bool suspended) {

  if (!userdata_has_field(state, "on_suspended")) {
    return;
  }
  run_on_main([this, &state, suspended](lua_State* l) {
    push_state(l, state);
    on_suspended(suspended);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_pre_draw() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param camera The camera where to draw the entity.
 */
void LuaContext::state_on_pre_draw(CustomState& state, Camera& camera) {

  if (!userdata_has_field(state, "on_pre_draw")) {
    return;
  }
  run_on_main([this, &state, &camera](lua_State* l) {
    push_state(l, state);
    on_pre_draw(camera);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_post_draw() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param camera The camera where to draw the entity.
 */
void LuaContext::state_on_post_draw(CustomState& state, Camera& camera) {

  if (!userdata_has_field(state, "on_post_draw")) {
    return;
  }
  run_on_main([this, &state, &camera](lua_State* l) {
    push_state(l, state);
    on_post_draw(camera);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_map_started() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param map The map.
 * \param destination Destination entity where the hero is placed or nullptr.
 */
void LuaContext::state_on_map_started(
    CustomState& state, Map& map, const std::shared_ptr<Destination>& destination) {

  if (!userdata_has_field(state, "on_map_started")) {
    return;
  }
  run_on_main([this, &state, &map, &destination](lua_State* l) {
    push_state(l, state);
    on_map_started(map, destination);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_map_opening_transition_finished() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param map The map.
 * \param destination Destination entity where the hero is placed or nullptr.
 */
void LuaContext::state_on_map_opening_transition_finished(
    CustomState& state, Map& map, const std::shared_ptr<Destination>& destination) {

  if (!userdata_has_field(state, "on_map_opening_transition_finished")) {
    return;
  }
  run_on_main([this, &state, &map, &destination](lua_State* l) {
    push_state(l, state);
    on_map_opening_transition_finished(map, destination);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_map_finished() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 */
void LuaContext::state_on_map_finished(CustomState& state) {

  if (!userdata_has_field(state, "on_map_finished")) {
    return;
  }
  run_on_main([this, &state](lua_State* l) {
    push_state(l, state);
    on_map_finished();
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_position_changed() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param xy The new coordinates.
 * \param layer The new layer.
 */
void LuaContext::state_on_position_changed(CustomState& state, const Point& xy, int layer) {

  if (!userdata_has_field(state, "on_position_changed")) {
    return;
  }
  run_on_main([this, &state, xy, layer](lua_State* l) {
    push_state(l, state);
    on_position_changed(xy, layer);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the state_on_ground_below_changed() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param ground_below The new ground below the entity.
 */
void LuaContext::state_on_ground_below_changed(CustomState& state, Ground ground_below) {

  if (!userdata_has_field(state, "on_ground_below_changed")) {
    return;
  }

  run_on_main([this, &state, ground_below](lua_State* l){
    push_state(l, state);
    on_ground_below_changed(ground_below);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_obstacle_reached() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param movement The movement that reached an obstacle.
 */
void LuaContext::state_on_obstacle_reached(CustomState& state, Movement& movement) {

  if (!userdata_has_field(state, "on_obstacle_reached")) {
    return;
  }
  run_on_main([this, &state, &movement](lua_State* l) {
    push_state(l, state);
    on_obstacle_reached(movement);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_movement_started() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param movement The movement that has just started.
 */
void LuaContext::state_on_movement_started(CustomState& state, Movement& movement) {

  if (!userdata_has_field(state, "on_movement_started")) {
    return;
  }

  run_on_main([this, &state, &movement](lua_State* l) {
    push_state(l, state);
    on_movement_started(movement);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_movement_changed() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param movement The movement of the entity.
 */
void LuaContext::state_on_movement_changed(CustomState& state, Movement& movement) {

  if (!userdata_has_field(state, "on_movement_changed")) {
    return;
  }

  run_on_main([this, &state, &movement](lua_State* l) {
    push_state(l, state);
    on_movement_changed(movement);
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_movement_finished() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 */
void LuaContext::state_on_movement_finished(CustomState& state) {

  if (!userdata_has_field(state, "on_movement_finished")) {
    return;
  }

  run_on_main([this, &state](lua_State* l) {
    push_state(l, state);
    on_movement_finished();
    lua_pop(l, 1);
  });
}

/**
 * \brief Calls the on_attacked_enemy() method of a Lua custom state.
 *
 * Does nothing if the method is not defined.
 *
 * \param state A custom state.
 * \param The enemy that was attacked.
 * \param enemy_sprite Sprite that was attacked if any.
 * \param attack How the enemy was attacked.
 * \param reaction How the enemy reacted to the attack.
 */
void LuaContext::state_on_attacked_enemy(
    CustomState& state,
    Enemy& enemy,
    Sprite* enemy_sprite,
    EnemyAttack attack,
    const EnemyReaction::Reaction& reaction
) {
  if (!userdata_has_field(state, "on_attacked_enemy")) {
    return;
  }

  run_on_main([this, &state, &enemy, &enemy_sprite, &attack, &reaction](lua_State* l) {
    push_state(l, state);
    on_attacked_enemy(enemy, enemy_sprite, attack, reaction);
    lua_pop(l, 1);
  });
}

/**
 * \brief Notifies a Lua custom state that an input event has just occurred.
 *
 * The appropriate callback in the state is triggered if it exists.
 * Also notifies the menus of the state if the state itself does not handle the
 * event.
 *
 * \param event The input event to handle.
 * \param state A custom state.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::state_on_input(CustomState& state, const InputEvent& event) {

  push_state(current_l, state);
  bool handled = on_input(event);
  if (!handled) {
    handled = menus_on_input(-1, event);
  }
  lua_pop(current_l, 1);
  return handled;
}

/**
 * \brief Calls the on_command_pressed() method of a Lua custom state.
 *
 * Also notifies the menus of the state if the state itself does not handle the
 * event.
 *
 * \param state A state.
 * \param command The command pressed.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::state_on_command_pressed(CustomState& state, GameCommand command) {

  bool handled = false;
  push_state(current_l, state);
  if (userdata_has_field(state, "on_command_pressed")) {
    handled = on_command_pressed(command);
  }
  if (!handled) {
    handled = menus_on_command_pressed(-1, command);
  }
  lua_pop(current_l, 1);
  return handled;
}

/**
 * \brief Calls the on_command_released() method of a Lua custom state.
 *
 * Also notifies the menus of the state if the state itself does not handle the
 * event.
 *
 * \param state A state.
 * \param command The command released.
 * \return \c true if the event was handled and should stop being propagated.
 */
bool LuaContext::state_on_command_released(CustomState& state, GameCommand command) {

  bool handled = false;
  push_state(current_l, state);
  if (userdata_has_field(state, "on_command_released")) {
    handled = on_command_released(command);
  }
  if (!handled) {
    handled = menus_on_command_released(-1, command);
  }
  lua_pop(current_l, 1);
  return handled;
}

}
