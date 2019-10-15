local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local state = sol.state.create()
  state:set_affected_by_ground("shallow_water", false)
  hero:start_state(state)
  
  assert_equal(hero:get_ground_below(), "shallow_water")
  game:simulate_command_pressed("right")
  
  sol.timer.start(map, 10, function()
    assert_equal(hero:get_movement():get_speed(), 88)  -- The ground should not affect the speed.
    sol.main.exit()
  end)

  sol.timer.start(map, 500, function()
    if hero:get_movement() ~= nil then
      print(hero:get_movement():get_speed())
    end
    return true
  end)
end
