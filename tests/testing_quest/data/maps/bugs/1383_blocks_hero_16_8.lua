local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  for sensor in map:get_entities_by_type("sensor") do
    sensor:set_size(16, 8)
  end

  hero:set_size(16, 8)
  hero:set_origin(8, 5)
  game:simulate_command_pressed("right")
end

function sensor_1:on_activated()
  game:simulate_command_released("right")
  game:simulate_command_pressed("down")
end

function sensor_2:on_activated()
  game:simulate_command_released("down")
  game:simulate_command_pressed("left")
end

function sensor_3:on_activated()
  game:simulate_command_released("left")
  game:simulate_command_pressed("up")
end

function sensor_4:on_activated()
  game:simulate_command_released("up")
  sol.main.exit()
end
