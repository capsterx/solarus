#pragma once

#include <SDL.h>

namespace nswitch
{
  bool PollEvent(SDL_Event *);
  struct Switch_Key_Map;
  extern struct Switch_Key_Map * keymap;
}
