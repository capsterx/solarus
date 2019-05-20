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
#include "solarus/core/Logger.h"
#include "solarus/core/System.h"
#include <sstream>

namespace Solarus {

inline void PerfCounter::update(const std::string& name) {
  uint32_t current_time = System::get_real_time();
  ++count[name];
  if (current_time - last_time >= interval) {
    last_time = current_time;
    std::ostringstream oss;
    oss << "PerfCounter:";
    for (auto it=count.begin(); it!=count.end(); ++it) {
      oss << " " << it->first << "=" << it->second;
      it->second = 0;
    }
    Logger::print(oss.str());
  }
}

}
