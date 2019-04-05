-- Lua script of map 1044_sol_menu_multiple_start.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
  
  
  local menu = {}
  
  sol.menu.start(map, menu)
  
  local status, err = pcall(sol.menu.start, map, menu)
  if not status then
    print('good error', err)
    sol.main.exit()
  else
    error('adding menu a second time should raise an error')
  end
  
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
