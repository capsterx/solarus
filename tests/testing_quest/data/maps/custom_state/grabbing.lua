local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local state = sol.state.create()
  assert_equal(state:get_can_grab(), true)
  state:set_can_grab(false)
  assert_equal(state:get_can_grab(), false)
  hero:start_state(state)
  assert_equal(hero:get_state(), "custom")
  assert_equal(hero:get_state_object(), state)
  game:simulate_command_pressed("action")
  assert_equal(hero:get_state_object(), state)
  game:simulate_command_released("action")

  state:set_can_grab(true)
  assert_equal(state:get_can_grab(), true)
  game:simulate_command_pressed("action")
  assert_equal(hero:get_state(), "grabbing")
  game:simulate_command_released("action")
  later(function()
    assert_equal(hero:get_state(), "free")

    hero:start_grabbing()
    assert_equal(hero:get_state(), "grabbing")
    sol.main.exit()
  end)
end
