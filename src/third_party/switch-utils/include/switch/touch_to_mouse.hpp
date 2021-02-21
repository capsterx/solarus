#pragma once
union SDL_Event;

namespace nswitch {
bool touch_to_mouse(int screenx, int screeny, SDL_Event const & event, bool);
}
