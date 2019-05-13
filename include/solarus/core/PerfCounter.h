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
#ifndef SOLARUS_PERF_COUNTER_H
#define SOLARUS_PERF_COUNTER_H

#include "solarus/core/Common.h"
#include <cstdint>
#include <map>
#include <string>

namespace Solarus {

class SOLARUS_API PerfCounter {

  public:

    static inline void update(const std::string& name);

    static constexpr uint32_t interval = 1000;  /**< Time interval for reporting in milliseconds. */

  private:

    static uint32_t last_time; /**< Last time of reporting in milliseconds. */
    static std::map<std::string,uint32_t> count; /**< Performance counts. */
};

}  // namespace Solarus

#include "PerfCounter.inl"

#endif
