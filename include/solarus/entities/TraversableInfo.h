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
#ifndef SOLARUS_TRAVERSABLE_INFO_H
#define SOLARUS_TRAVERSABLE_INFO_H

#include "solarus/lua/ScopedLuaRef.h"

namespace Solarus {

class Entity;
class ExportableToLua;
class LuaContext;

/**
 * \brief Stores whether a custom entity can be traversed by or can traverse
 * other entities.
 */
class TraversableInfo {

  public:

    TraversableInfo();
    TraversableInfo(
        LuaContext& lua_context,
        bool traversable
    );
    TraversableInfo(
        LuaContext& lua_context,
        const ScopedLuaRef& traversable_test_ref
    );

    bool is_empty() const;
    bool is_traversable(
        ExportableToLua& userdata,
        Entity& other_entity
    ) const;

  private:

    LuaContext* lua_context;       /**< The Lua world.
                                    * nullptr means no info. */
    ScopedLuaRef
        traversable_test_ref;      /**< Lua ref to a boolean function
                                    * that decides, or LUA_REFNIL. */
    bool traversable;              /**< Traversable property (unused if
                                    * there is a Lua function). */
};

}

#endif
