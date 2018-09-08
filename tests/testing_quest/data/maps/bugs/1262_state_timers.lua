local map = ...
local game = map:get_game()

local state = sol.state.create()

local function test_cancel()
  -- Test a timer canceled by the end of the state.
  sol.timer.start(state, 100, function()
    hero:unfreeze()  -- Change the state: state timers should be canceled.
  end)
  sol.timer.start(state, 500, function()
    assert(false)  -- This timer should have be cancelled.
  end)
  sol.timer.start(sol.main, 1000, sol.main.exit)
end

function map:on_opening_transition_finished()

  hero:start_state(state)

  local initial_time = sol.main.get_elapsed_time()

  -- Test a timer duration with a pause in the meantime.
  local state_timer = sol.timer.start(state, 500, function()
    assert_equal(sol.main.get_elapsed_time() - initial_time, 700)
    test_cancel()  -- Start second test.
  end)

  sol.timer.start(sol.main, 100, function()
    assert(not state_timer:is_suspended())
    game:set_suspended(true)
    later(function()
      assert(state_timer:is_suspended())
      sol.timer.start(sol.main, 100, function()
        assert(state_timer:is_suspended())
        game:set_suspended(false)
        later(function()
          assert(not state_timer:is_suspended())
        end)
      end)
    end)
  end)

end
