local map = ...
local game = map:get_game()

local state_1
local state_2
local state_3
local expected_jump_time

function hero:on_state_changed(state)

  if state == "jumping" then
    assert_equal(sol.main.get_elapsed_time(), expected_jump_time)
  end
end

function map:on_opening_transition_finished()

  sol.timer.start(map, 4000, function()
    assert_equal_xy(hero, jumper_3_before_sensor)
    sol.main.exit()
  end)

  state_1 = sol.state.create()
  assert_equal(state_1:get_can_use_jumper(), true)
  assert_equal(state_1:get_jumper_delay(), 200)
  state_1:set_jumper_delay(500)
  assert_equal(state_1:get_jumper_delay(), 500)
  hero:start_state(state_1)
  hero:set_animation("walking")
  game:simulate_command_pressed("down")

  function jumper_1_before_sensor:on_activated()
    assert_equal(hero:get_state(), "custom")
    assert_equal(hero:get_state_object(), state_1)
    assert_equal(state_1:get_jumper_delay(), 500)
    expected_jump_time = sol.main.get_elapsed_time() + state_1:get_jumper_delay()
  end
end

function jumper_1_after_sensor:on_activated()

  assert_equal(hero:get_state(), "jumping")
  assert_equal(hero:get_state_object(), nil)

  state_2 = sol.state.create()
  assert_equal(state_2:get_can_use_jumper(), true)
  state_2:set_can_use_jumper(true)
  assert_equal(state_2:get_can_use_jumper(), true)
  assert_equal(state_2:get_jumper_delay(), 200)
  state_2:set_jumper_delay(0)
  assert_equal(state_2:get_jumper_delay(), 0)
  hero:start_state(state_2)
  hero:set_animation("walking")
end

function jumper_2_before_sensor:on_activated()
  assert_equal(hero:get_state(), "custom")
  assert_equal(hero:get_state_object(), state_2)
  assert_equal(state_2:get_jumper_delay(), 0)
  expected_jump_time = sol.main.get_elapsed_time() + state_2:get_jumper_delay()
end

function jumper_2_after_sensor:on_activated()

  assert_equal(hero:get_state(), "jumping")
  assert_equal(hero:get_state_object(), nil)

  state_3 = sol.state.create()
  assert_equal(state_3:get_can_use_jumper(), true)
  state_3:set_can_use_jumper(false)
  assert_equal(state_3:get_can_use_jumper(), false)
  hero:start_state(state_3)
  hero:set_animation("walking")
end
