local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  hero:set_walking_speed(800)
  game:simulate_command_pressed("right")
  game:simulate_command_pressed("down")
  
end

function end_sensor:on_activated()
  sol.main.exit()
end
