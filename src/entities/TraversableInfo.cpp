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
#include "solarus/entities/TraversableInfo.h"
#include "solarus/lua/LuaContext.h"

namespace Solarus {

/**
 * \brief Empty constructor.
 */
TraversableInfo::TraversableInfo():
    lua_context(nullptr),
    traversable_test_ref(),
    traversable(false) {

}

/**
 * \brief Creates a boolean traversable property.
 * \param lua_context The Lua context.
 * \param traversable The value to store.
 */
TraversableInfo::TraversableInfo(
    LuaContext& lua_context,
    bool traversable
):
    lua_context(&lua_context),
    traversable_test_ref(),
    traversable(traversable) {

}

/**
 * \brief Creates a traversable property as a Lua boolean function.
 * \param lua_context The Lua context.
 * \param traversable_test_ref Lua ref to a function.
 */
TraversableInfo::TraversableInfo(
    LuaContext& lua_context,
    const ScopedLuaRef& traversable_test_ref
):
    lua_context(&lua_context),
    traversable_test_ref(traversable_test_ref),
    traversable(false) {

}

/**
 * \brief Returns whether this traversable property is empty.
 * \return \c true if no property is set.
 */
bool TraversableInfo::is_empty() const {

  return lua_context == nullptr;
}

/**
 * \brief Tests this traversable property with the specified other entity.
 *
 * This traversable property must not be empty.
 *
 * \param current_object The Lua userdata to test.
 * \param other_entity Another entity.
 * \return \c true if traversing is allowed, \c false otherwise.
 */
bool TraversableInfo::is_traversable(
    ExportableToLua& userdata,
    Entity& other_entity
) const {

  Debug::check_assertion(!is_empty(), "Empty traversable info");

  if (traversable_test_ref.is_empty()) {
    // A fixed boolean was set.
    return traversable;
  }

  // A Lua boolean function was set.
  return lua_context->do_traversable_test_function(
      traversable_test_ref, userdata, other_entity
  );
}

}
