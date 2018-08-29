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

  return LuaTools::exception_boundary_handle(l, [&] {
    const std::string& name = LuaTools::opt_string(l, 1, "");

    std::shared_ptr<CustomState> state = std::make_shared<CustomState>(name);

    push_state(l, *state);
    return 1;
  });
}

}
