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
#include "solarus/core/CurrentQuest.h"
#include "solarus/core/Game.h"
#include "solarus/core/Map.h"
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
    { "is_stopping", state_api_is_stopping },
    { "get_can_control_direction", state_api_get_can_control_direction },
    { "set_can_control_direction", state_api_set_can_control_direction },
    { "get_can_control_movement", state_api_get_can_control_movement },
    { "set_can_control_movement", state_api_set_can_control_movement },
    { "is_affected_by_ground", state_api_is_affected_by_ground },
    { "set_affected_by_ground", state_api_set_affected_by_ground },
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
 * \brief Implementation of sol.state.create().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_create(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const std::string& description = LuaTools::opt_string(l, 1, "");

    std::shared_ptr<CustomState> state = std::make_shared<CustomState>(description);

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
 * \brief Implementation of state:is_stopping().
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int LuaContext::state_api_is_stopping(lua_State* l) {

  return state_boundary_handle(l, [&] {
    const CustomState& state = *check_state(l, 1);

    lua_pushboolean(l, state.is_stopping());
    return 1;
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
    bool can_control_direction = LuaTools::opt_boolean(l, 2, true);

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
    bool can_control_movement = LuaTools::opt_boolean(l, 2, true);

    state.set_can_control_movement(can_control_movement);

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

  push_state(current_l, state);
  if (userdata_has_field(state, "on_finished")) {
    on_finished(next_state_name, next_state);
  }
  remove_timers(-1);  // Stop timers associated to this state.
  lua_pop(current_l, 1);
}

}
