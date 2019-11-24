local map = ...
local game = map:get_game()

function map:on_started()
  game:set_ability("swim", 1)
end

function map:on_opening_transition_finished()
  game:simulate_command_pressed("right")
end

function deep_water_sensor:on_activated()
  assert_equal(hero:get_state(), "swimming")
  local movement = hero:get_movement()
  assert_equal(movement:get_speed(), 44)
end

function shallow_water_sensor:on_activated()
  assert_equal(hero:get_state(), "free")
  assert_equal(hero:get_ground_below(), "shallow_water")
  local movement = hero:get_movement()
  assert_equal(movement:get_speed(), 70)
  sol.main.exit()
end
