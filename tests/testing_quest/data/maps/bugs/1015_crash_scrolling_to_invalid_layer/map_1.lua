local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  game:simulate_command_pressed("left")
end
