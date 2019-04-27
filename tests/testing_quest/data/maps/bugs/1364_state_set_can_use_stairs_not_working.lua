local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local state = sol.state.create()
  state:set_can_control_direction(false)
  state:set_can_use_stairs(true)
  hero:start_state(state)
  game:simulate_command_pressed("left")
  sol.timer.start(map, 2000, function()
    assert_equal(hero:get_layer(), 1)
    sol.main.exit()
  end)
end
