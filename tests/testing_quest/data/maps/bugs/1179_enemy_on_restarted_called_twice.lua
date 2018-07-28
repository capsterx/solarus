local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  sol.timer.start(map, 100, function()
    assert_equal(enemy:get_on_restarted_count(), 1)
    sol.main.exit()
  end)
end
