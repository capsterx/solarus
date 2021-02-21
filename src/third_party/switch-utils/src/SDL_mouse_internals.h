#pragma once
#include <SDL.h>

#ifdef __cplusplus
extern "C" {
#endif
typedef Uint32 SDL_MouseID;

struct SDL_Cursor
{
    struct SDL_Cursor *next;
    void *driverdata;
};

typedef struct
{
    int last_x, last_y;
    Uint32 last_timestamp;
    Uint8 click_count;
} SDL_MouseClickState;
typedef struct
{
    /* Create a cursor from a surface */
    SDL_Cursor *(*CreateCursor) (SDL_Surface * surface, int hot_x, int hot_y);

    /* Create a system cursor */
    SDL_Cursor *(*CreateSystemCursor) (SDL_SystemCursor id);

    /* Show the specified cursor, or hide if cursor is NULL */
    int (*ShowCursor) (SDL_Cursor * cursor);

    /* This is called when a mouse motion event occurs */
    void (*MoveCursor) (SDL_Cursor * cursor);

    /* Free a window manager cursor */
    void (*FreeCursor) (SDL_Cursor * cursor);

    /* Warp the mouse to (x,y) within a window */
    void (*WarpMouse) (SDL_Window * window, int x, int y);

    /* Warp the mouse to (x,y) in screen space */
    int (*WarpMouseGlobal) (int x, int y);

    /* Set relative mode */
    int (*SetRelativeMouseMode) (SDL_bool enabled);

    /* Set mouse capture */
    int (*CaptureMouse) (SDL_Window * window);

    /* Get absolute mouse coordinates. (x) and (y) are never NULL and set to zero before call. */
    Uint32 (*GetGlobalMouseState) (int *x, int *y);

    /* Data common to all mice */
    SDL_MouseID mouseID;
    SDL_Window *focus;
    int x;
    int y;
    int xdelta;
    int ydelta;
    int last_x, last_y;         /* the last reported x and y coordinates */
    float accumulated_wheel_x;
    float accumulated_wheel_y;
    Uint32 buttonstate;
    SDL_bool has_position;
    SDL_bool relative_mode;
    SDL_bool relative_mode_warp;
    float normal_speed_scale;
    float relative_speed_scale;
    float scale_accum_x;
    float scale_accum_y;
    Uint32 double_click_time;
    int double_click_radius;
    SDL_bool touch_mouse_events;
    SDL_bool mouse_touch_events;
    SDL_bool was_touch_mouse_events; /* Was a touch-mouse event pending? */

    /* Data for double-click tracking */
    int num_clickstates;
    SDL_MouseClickState *clickstate;

    SDL_Cursor *cursors;
    SDL_Cursor *def_cursor;
    SDL_Cursor *cur_cursor;
    SDL_bool cursor_shown;

    /* Driver-dependent data. */
    void *driverdata;
} SDL_Mouse;

SDL_Mouse *SDL_GetMouse(void);

int SDL_SendMouseMotion	(SDL_Window *window, SDL_MouseID mouseID,
		int 	relative,
		int 	x,
		int 	y 
		);
int SDL_SendMouseButton	(SDL_Window * 	window,
		SDL_MouseID 	mouseID,
		uint8_t 	state,
		uint8_t 	button 
		);

#ifdef __cplusplus
}
#endif
