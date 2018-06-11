-- Lua script of map oriented_collisions.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local math = require('math')

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
end

local i = 0
local cx,cy = pivot:get_position()
  local hx,hy = in_hole:get_position()
  local tx,ty = on_tip:get_position()
  local hr = hx-cx;
  local tr = tx-cx;
function map:on_update()  
  local angle = (i/100.0)*math.pi*2;
  local sina = math.sin(-angle)
  local cosa = math.cos(-angle)
  in_hole:set_position(cx+cosa*hr,cy+sina*hr)
  --print('position',in_hole:get_position())
  on_tip:set_position(cx+cosa*tr,cy+sina*tr)
  pivot:get_sprite():set_rotation(angle)
  assert_equal(pivot:overlaps(on_tip,'sprite'),true)
  assert_equal(pivot:overlaps(in_hole,'sprite'),false)
  i = i+1
  if i > 100 then sol.main.exit() end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()
end
