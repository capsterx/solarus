#pragma once
#include <cstring>

union SDL_Event;

namespace nswitch {
bool rstick_to_mouse(SDL_Event const & event);
}
