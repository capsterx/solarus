#include "SDL.h"

namespace nswitch {
  int joy_init()
  {
    if (SDL_InitSubSystem(SDL_INIT_JOYSTICK|SDL_INIT_GAMECONTROLLER) != 0)
    {
      printf("Error init joystick: %s\n", SDL_GetError());
    }
    int joysticks = SDL_NumJoysticks();
    printf("%d joysticks on system\n", joysticks);
    for (int i = 0; i < joysticks; i++) {
        if (SDL_IsGameController(i))
        {
            if (SDL_GameControllerOpen(i) == NULL)
            {
                const char* error = SDL_GetError();
                printf("Warning : Unable to open game controller %s: %s\n", SDL_JoystickNameForIndex(i), error);
            }
        }
        printf("  - joystick %d (%s) : %s\n", i, SDL_IsGameController(i) ? "controller" : " joystick ", SDL_JoystickNameForIndex(i));
    }
    return joysticks > 0;
  }
}

extern "C" {
int switch_joy_init()
{
  return nswitch::joy_init();
}
}
