-- Lua script of map bugs/1175_dynamic_tile_set_get_tileset.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  -- Initially We should be using the map's tileset.
  assert(nil == magic_carpet:get_tileset())

  -- Try changing it to a value.
  sol.timer.start(500, function()
    magic_carpet:set_tileset("castle_grayscale")
    assert("castle_grayscale" == magic_carpet:get_tileset())
  end)

  -- Try clearing it/set to nil.
  sol.timer.start(1000, function()
    magic_carpet:set_tileset(nil)
    assert(nil == magic_carpet:get_tileset())
  end)

  -- End after a delay (for visual reviews).
  sol.timer.start(1500, function()
    sol.main.exit()
  end)
end
