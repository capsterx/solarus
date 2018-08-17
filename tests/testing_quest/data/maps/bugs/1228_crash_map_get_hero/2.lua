local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  sol.timer.start(500, function()
    sol.main.exit()
  end)
end
