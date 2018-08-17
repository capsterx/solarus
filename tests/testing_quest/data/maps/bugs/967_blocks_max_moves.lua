local map = ...
local game = map:get_game()

-- Blocks 1, 2, 3: max moves set from the quest editor with old format.
-- Blocks 4, 5, 6: max moves set from this script with old API.
-- Blocks 7, 8, 9: max moves set from the quest editor with new format.
-- Blocks 10, 11, 12: max moves set from this script with new API.

function map:on_started()

  block_4:set_maximum_moves(0)
  block_5:set_maximum_moves(1)
  block_6:set_maximum_moves(nil)

  block_10:set_max_moves(0)
  block_11:set_max_moves(2)
  block_12:set_max_moves(nil)
end

function map:on_opening_transition_finished()

  game:simulate_command_pressed("left")
  sol.timer.start(map, 1000, function()
    game:simulate_command_released("left")
    game:simulate_command_pressed("right")
    sol.timer.start(map, 2000, function()
      game:simulate_command_released("right")
      game:simulate_command_pressed("down")
      sol.timer.start(map, 3000, function()
        game:simulate_command_released("down")
        game:simulate_command_pressed("left")
        sol.timer.start(map, 1000, function()
          game:simulate_command_released("left")
          game:simulate_command_pressed("right")
          sol.timer.start(map, 2000, function()
            game:simulate_command_released("right")
            game:simulate_command_pressed("down")
            sol.timer.start(map, 3000, function()
              game:simulate_command_released("down")
              game:simulate_command_pressed("left")
              sol.timer.start(map, 1000, function()
                game:simulate_command_released("left")
                game:simulate_command_pressed("right")
                sol.timer.start(map, 2000, function()
                  game:simulate_command_released("right")
                  game:simulate_command_pressed("down")
                  sol.timer.start(map, 3000, function()
                    game:simulate_command_released("down")
                    game:simulate_command_pressed("left")
                    sol.timer.start(map, 1000, function()
                      game:simulate_command_released("left")
                      game:simulate_command_pressed("right")
                      sol.timer.start(map, 4000, function()
                        game:simulate_command_released("right")
                        game:simulate_command_pressed("down")
                        sol.timer.start(map, 4000, function()
                          game:simulate_command_released("down")
                          for i = 1, 12 do
                            local block = map:get_entity("block_" .. i)
                            local block_x, block_y = block:get_position()
                            local target = map:get_entity("block_target_" .. i)
                            local target_x, target_y = target:get_position()
                            assert_equal(block_x, target_x)
                            assert_equal(block_y, target_y) 
                          end
                          sol.main.exit()
                        end)
                      end)
                    end)
                  end)
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end)
end
