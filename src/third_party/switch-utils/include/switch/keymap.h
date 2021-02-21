#pragma once

#include "SDL.h"

struct Switch_Key_Map;
//struct Switch_Key_Map * switch_keymap_create();
struct Switch_Key_Map * switch_keymap_create();
void switch_keymap_set_screen(struct Switch_Key_Map *, int, int);
int switch_keymap_load_from_file(struct Switch_Key_Map *, char const *);
void switch_keymap_set_mouse_movement(struct Switch_Key_Map *, int);
void switch_keymap_set_index(struct Switch_Key_Map *, int);
int switch_keymap_event(struct Switch_Key_Map *, SDL_Event const *);
void switch_keymap_destroy(struct Switch_Key_Map *);
