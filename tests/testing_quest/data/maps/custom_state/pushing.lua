local map = ...
local game = map:get_game()
local expected_push_time

function map:on_opening_transition_finished()

  -- 1: Pushing allowed with default delay (1000).
  local state = sol.state.create()
  assert_equal(state:get_can_push(), true)
  assert_equal(state:get_pushing_delay(), 1000)
  hero:start_state(state)
  assert_equal(hero:get_state(), "custom")
  assert_equal(hero:get_custom_state(), state)
  game:simulate_command_pressed("down")
end

function sensor_1:on_activated()

  assert_equal(hero:get_state(), "custom")
  local state = hero:get_custom_state()
  assert(state ~= nil)
  assert_equal(state:get_can_push(), true)
  assert_equal(state:get_pushing_delay(), 1000)

  -- Add 10 to the expected date because the obstacle is reached later than the sensor.
  expected_push_time = sol.main.get_elapsed_time() + state:get_pushing_delay() + 10

  sol.timer.start(map, 2000, function()
    assert_equal(hero:get_state(), "pushing")

    -- 2: Pushing allowed with custom delay (300).
    local state = sol.state.create()
    assert_equal(state:get_can_push(), true)
    state:set_can_push(true)
    assert_equal(state:get_can_push(), true)
    assert_equal(state:get_pushing_delay(), 1000)
    state:set_pushing_delay(300)
    assert_equal(state:get_pushing_delay(), 300)
    hero:start_state(state)
    assert_equal(hero:get_state(), "custom")
    assert_equal(hero:get_custom_state(), state)
    game:simulate_command_released("down")
    game:simulate_command_pressed("right")
  end)
end

function sensor_2:on_activated()

  assert_equal(hero:get_state(), "custom")
  local state = hero:get_custom_state()
  assert(state ~= nil)
  assert_equal(state:get_can_push(), true)
  assert_equal(state:get_pushing_delay(), 300)
  expected_push_time = sol.main.get_elapsed_time() + state:get_pushing_delay() + 10
  sol.timer.start(map, 1000, function()
    assert_equal(hero:get_state(), "pushing")

    -- 3: Pushing not allowed.
    local state = sol.state.create()
    assert_equal(state:get_can_push(), true)
    state:set_can_push(false)
    assert_equal(state:get_can_push(), false)
    assert_equal(state:get_pushing_delay(), 1000)
    hero:start_state(state)
    assert_equal(hero:get_state(), "custom")
    assert_equal(hero:get_custom_state(), state)
    game:simulate_command_released("right")
    game:simulate_command_pressed("down")
  end)
end

function sensor_3:on_activated()

  assert_equal(hero:get_state(), "custom")
  local state = hero:get_custom_state()
  assert(state ~= nil)
  assert_equal(state:get_can_push(), false)
  assert_equal(state:get_pushing_delay(), 1000)
  expected_push_time = nil
  sol.timer.start(map, 2000, function()
    assert_equal(hero:get_state(), "custom")
    local state = hero:get_custom_state()
    assert(state ~= nil)
    assert_equal(state:get_can_push(), false)
    assert_equal(state:get_pushing_delay(), 1000)
    sol.main.exit()
  end)
end

function hero:on_state_changed(state)

  if state == "pushing" then
    assert(expected_push_time ~= nil)
    assert_equal(sol.main.get_elapsed_time(), expected_push_time)
  end
end