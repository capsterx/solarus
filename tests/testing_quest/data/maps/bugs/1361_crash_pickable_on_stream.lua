local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  sol.timer.start(map, 3000, function()
    assert(pickable_1:get_controlling_stream() ~= nil)
    assert(pickable_2:get_controlling_stream() ~= nil)
    sol.main.exit()
  end)
end
