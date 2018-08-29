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
#include "solarus/hero/HeroState.h"

namespace Solarus {

/**
 * \brief The state "custom" of the hero.
 *
 * Delegates everything to a Lua object of type state.
 */
class CustomState: public HeroState {

  public:

    explicit CustomState(const std::string& name);
    const std::string& get_lua_type_name() const override;

  private:

    std::string name;  /**< Name of this state or an empty string. */
};

}

#endif

