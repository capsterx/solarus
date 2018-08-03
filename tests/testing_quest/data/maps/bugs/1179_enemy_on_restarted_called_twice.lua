local map = ...
local game = map:get_game()

function map:on_started()

  sol.timer.start(map, 10, function()
    -- Check that on_restarted() is called before map:on_opening_transition_finished().
    assert_equal(enemy:get_on_restarted_count(), 1)
  end)
end

function map:on_opening_transition_finished()

    -- Check that on_restarted() is not called a second time here.
  assert_equal(enemy:get_on_restarted_count(), 1)
  sol.timer.start(map, 10, function()
    assert_equal(enemy:get_on_restarted_count(), 1)
    sol.main.exit()
  end)
end
