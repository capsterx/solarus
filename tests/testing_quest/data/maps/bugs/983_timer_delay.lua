local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local delay = 100
  local expected_time = sol.main.get_elapsed_time() + delay
  local timer = sol.timer.start(map, delay, function()
    assert_equal(sol.main.get_elapsed_time(), expected_time)

    if expected_time > 5000 then
      sol.main.exit()
    end

    if delay < 500 then
      -- Returning true should now repeat the timer with the last delay
      expected_time = expected_time + delay
      return true
    end

    delay = delay + 100
    expected_time = expected_time + delay
    return delay
  end)
end
