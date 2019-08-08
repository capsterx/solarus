local map = ...
local game = map:get_game()
local hero = game:get_hero()

function map:on_opening_transition_finished()

  game:simulate_command_pressed("action")
  game:simulate_command_pressed("left")
end

function switch:on_activated()
  hero:unfreeze()
  sol.main.exit()
end
