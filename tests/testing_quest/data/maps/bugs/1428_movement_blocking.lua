-- Lua script of map bugs/1428_movement_blocking.
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
  
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()
  
end

function start_sensor:on_activated()
  game:simulate_command_pressed('right')
end

function ramp_sensor:on_activated()
  game:simulate_command_pressed('up')
  sol.timer.start(map, 5, function()
    game:simulate_command_released('right')
  end)
end

function diagonal_sensor:on_activated()
  game:simulate_command_pressed('left')
end

function success_sensor:on_activated()
  sol.main.exit()
end

function fail_sensor:on_activated()
  error("hero should not have landed here")
end
