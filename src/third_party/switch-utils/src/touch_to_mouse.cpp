#include "switch/touch_to_mouse.hpp"
#include <SDL.h>
#include "SDL_mouse_internals.h"

namespace nswitch {
bool touch_to_mouse (int screenx, int screeny, SDL_Event const & event, bool mouse_movement)
{
  if (event.type == SDL_FINGERDOWN || event.type == SDL_FINGERUP)
  {
     SDL_Finger* finger0 = SDL_GetTouchFinger(event.tfinger.touchId, 0);
     int numFingers = 0;
     if (finger0) {
     	numFingers = SDL_GetNumTouchFingers(event.tfinger.touchId);
     }
     auto mouse = SDL_GetMouse();
     SDL_GetWindowSize(mouse->focus, &screenx, &screeny);
     if (numFingers == 1) {
       if (mouse_movement)
       {
         int x = (float)screenx * event.tfinger.x;
         int y = (float)screeny * event.tfinger.y;
         //printf("oldx=%d newx%d - oldy=%d newy=%d\n",
          //	       mouse->last_x, x, mouse->last_y, y);
         //SDL_WarpMouseInWindow(NULL, x, y);
         //SDL_SendMouseMotion(NULL, 0, 0, x, y);
         //??????
         //mouse->touch_mouse_events = SDL_TRUE;
         //auto oldrel = mouse->relative_mode;
         //mouse->relative_mode = SDL_FALSE;
         SDL_SendMouseMotion(SDL_GetMouse()->focus, 0, SDL_FALSE, x, y);
         //mouse->relative_mode = oldrel;
         //mouse->touch_mouse_events = SDL_FALSE;
       }
       if(event.type == SDL_FINGERDOWN)
       {
         SDL_SendMouseButton(NULL, 0, SDL_PRESSED, SDL_BUTTON_LEFT);
       }
     }
     if (event.type == SDL_FINGERUP)
     {
       SDL_SendMouseButton(NULL, 0, SDL_RELEASED, SDL_BUTTON_LEFT);
     }
     return true;
  } 
  return false;
}
}

extern "C" {
  int switch_touch_to_mouse(int screenx, int screeny, SDL_Event const * event, bool movement)
  {
    return nswitch::touch_to_mouse(screenx, screeny, *event, movement);
  }
}
