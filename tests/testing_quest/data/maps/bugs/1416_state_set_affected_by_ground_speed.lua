local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local state = sol.state.create()
  state:set_affected_by_ground("shallow_water", false)
  state:set_affected_by_ground("hole", false)
  hero:start_state(state)

  assert_equal(hero:get_ground_below(), "shallow_water")
  game:simulate_command_pressed("right")
  
  sol.timer.start(map, 1000, function()
    assert(hero:get_movement() ~= nil)
    assert_equal(hero:get_movement():get_speed(), 88)  -- The ground should not affect the speed.
    assert(hero:get_sprite("ground") == nil)
    sol.main.exit()
  end)
end
