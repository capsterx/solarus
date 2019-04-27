local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  sol.timer.start(map, 100, sol.main.exit)
end
