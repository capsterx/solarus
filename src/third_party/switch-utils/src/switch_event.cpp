#include <switch/switch_event.hpp>
#include <switch/keymap.hpp>

namespace nswitch
{
  struct Switch_Key_Map * keymap=nullptr;
  bool PollEvent(SDL_Event * ev)
  {
    while (SDL_PollEvent(ev)) {
      if (keymap) {
        if (keymap->event(*ev))
        {
          continue;
        }
	return true;
      }
      else
      {
        return true;
      }
    }
    return false;
  }
}
