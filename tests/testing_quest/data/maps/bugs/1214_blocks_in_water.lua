local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  assert(block_1 ~= nil)
  assert(block_2 ~= nil)
  assert(block_3 ~= nil)

  game:simulate_command_pressed("up")
  sol.timer.start(map, 2000, function()
    game:simulate_command_released("up")
    game:simulate_command_pressed("right")
    sol.timer.start(map, 2000, function()
      game:simulate_command_released("right")
      game:simulate_command_pressed("down")
    end)
  end)
end

function expected_final_position_sensor:on_activated()

  assert(block_1 == nil)
  assert(block_2 == nil)
  assert(block_3 == nil)
  sol.main.exit()
end
