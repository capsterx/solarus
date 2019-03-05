-- Lua script of map bugs/1353_water_no_flippers.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = game:get_hero()

-- add needed assert helpers
function hero:assert_position_equal(other)

  local x_1, y_1, layer_1 = hero:get_position()
  local x_2, y_2, layer_2 = other:get_position()
  assert(x_1 == x_2)
  assert(y_1 == y_2)
  assert(layer_1 == layer_2)
end

function hero:assert_state_ground_animation(state, ground, animation)

  assert_equal(hero:get_state(), state)

  local map = hero:get_map()
  local hero_x, hero_y, hero_layer = hero:get_ground_position()
  assert_equal(map:get_ground(hero_x, hero_y, hero_layer), ground)
  assert_equal(hero:get_ground_below(), ground)

  assert_equal(hero:get_sprite("tunic"):get_animation(), animation)
end

-- very important : define this
function hero:on_movement_changed()
end

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  -- go down to do the jump
  game:simulate_command_pressed('down')
end

function to_water:on_activated()
  sol.timer.start(sol.main, 3000, function()
      sol.main.exit() --quit test if done
  end)
end