-- Lua script of map bugs/1038_hero_hurt_in_stairs.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = game:get_hero()
-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
  game:simulate_command_pressed('up')
end

function hero:on_state_changed(state)
  --print(state)
  if state == 'hurt' then
    error("hero should not be hurt in stairs")
  end
end

function arrival:on_activated()
  sol.main.exit()
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
