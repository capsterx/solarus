local map = ...
local game = map:get_game()

function map:on_started()
  hero:assert_position_equal(sensor_on_started)
end

function map:on_opening_transition_finished()
  if go_up_sensor ~= nil then  -- Multiple entry points.
    hero:assert_position_equal(sensor_on_opening_transition_finished)
  elseif go_right_sensor ~= nil then
    hero:assert_position_equal(sensor_on_opening_transition_finished_2)
  elseif go_down_sensor ~= nil then
    hero:assert_position_equal(sensor_on_opening_transition_finished_3)
  else
    hero:assert_position_equal(sensor_on_opening_transition_finished_4)
  end
end

function go_up_sensor:on_activated()
  hero:freeze()
  hero:unfreeze()

  game:simulate_command_released("right")
  game:simulate_command_pressed("up")
  go_up_sensor:remove()
end

function go_right_sensor:on_activated()
  hero:freeze()
  hero:unfreeze()

  game:simulate_command_released("up")
  game:simulate_command_pressed("right")
  go_right_sensor:remove()
end

function go_down_sensor:on_activated()
  hero:freeze()
  hero:unfreeze()

  game:simulate_command_released("right")
  game:simulate_command_pressed("down")
  go_down_sensor:remove()
end

function end_sensor:on_activated()
  sol.main.exit()
end
