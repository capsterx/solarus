#include "switch/rstick_to_mouse.hpp"
#include "switch/joymap.hpp"
#include "SDL_mouse_internals.h"


namespace nswitch {

static int rstick_motion_modifier = 0x1500;

bool rstick_to_mouse(SDL_Event const & event)
{
  //printf("%d\n", event.type);
  if (event.type == SDL_JOYAXISMOTION || event.type == SDL_CONTROLLERAXISMOTION)
  {
    //printf("%d - %d\n", event.type, event.caxis.axis);
    if (event.caxis.axis == 2 || event.caxis.axis == 3)
    {
      int x=0;
      int y=0;
      //SDL_GetMouseState(&x, &y);
      //printf("Original %d/%d ", x, y);
      if(event.caxis.axis == 2)
      {
        x = (event.caxis.value / rstick_motion_modifier);
      }
      else
      {
        y = (event.caxis.value / rstick_motion_modifier);
      }
      //printf("axis=%d value=%d %d/%d\n", event.caxis.axis, event.caxis.value, x, y);
      //printf("Sending mouse motion:  %d - %d\n", x, y);
      //SDL_WarpMouseInWindow(NULL, x, y);
      SDL_SendMouseMotion(SDL_GetMouse()->focus, 0, SDL_TRUE, x, y);
      return true;
    }
  }
  else if (event.type == SDL_JOYBUTTONDOWN || event.type == SDL_JOYBUTTONUP)
  {
    if (event.jbutton.button == (int)Switch_Joy::RSTICK)
    {
      SDL_SendMouseButton(NULL, 0, event.type == SDL_JOYBUTTONDOWN ? SDL_PRESSED : SDL_RELEASED, SDL_BUTTON_LEFT);
      return true;
    }
  }
  else if (event.type == SDL_CONTROLLERBUTTONDOWN || event.type == SDL_CONTROLLERBUTTONUP)
  {
    if (event.cbutton.button == SDL_CONTROLLER_BUTTON_RIGHTSTICK)
    {
      SDL_SendMouseButton(NULL, 0, event.type == SDL_JOYBUTTONDOWN ? SDL_PRESSED : SDL_RELEASED, SDL_BUTTON_LEFT);
      return true;
    }
  }
  return false;
}

}

extern "C" {
int switch_rstick_to_mouse(SDL_Event const * event)
{
  return nswitch::rstick_to_mouse(*event);
}

void switch_rstick_motion_modifier(int x)
{
  nswitch::rstick_motion_modifier = x;
}
}
