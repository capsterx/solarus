local map = ...
local game = map:get_game()
  local step = 0

function map:on_opening_transition_finished()
  local state = sol.state.create()
  assert_equal(state:get_can_be_hurt(), true)
  state:set_can_be_hurt(function(s, attacker)
    assert_equal(s, state)
    step = step + 1
    if step == 1 then
      assert_equal(attacker, nil)
      assert(not enemy:is_enabled())
      enemy:set_enabled(true)
      assert(enemy:is_enabled())
      return false
    elseif step == 2 then
      assert_equal(attacker, enemy)
      return false
    elseif step == 3 then
      assert_equal(attacker, enemy)
      return true
    end
  end)
  assert_equal(step, 0)
  assert_equal(state:get_can_be_hurt(), false)  -- Executes the callback.
  assert_equal(step, 1)
  hero:start_state(state)
  enemy:set_enabled(true)
end

function hero:on_state_changed(state)
  if state == "hurt" then
    assert_equal(step, 3)
    sol.main.exit()
  end
end
