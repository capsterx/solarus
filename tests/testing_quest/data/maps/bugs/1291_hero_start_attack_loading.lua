local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  game:set_ability("sword", 1)
  game:simulate_command_pressed("attack")
  hero:start_attack_loading()
  sol.timer.start(map, 990, function()
    assert_equal(hero:get_state(), "sword loading")
    game:simulate_command_released("attack")
    later(function()
      assert_equal(hero:get_state(), "free")

      game:simulate_command_pressed("attack")
      hero:start_attack_loading()
      sol.timer.start(map, 1010, function()
        assert_equal(hero:get_state(), "sword loading")
        game:simulate_command_released("attack")
        later(function()
          assert_equal(hero:get_state(), "sword spin attack")

          game:simulate_command_pressed("attack")
          hero:start_attack_loading(0)
          assert_equal(hero:get_state(), "sword spin attack")
          hero:unfreeze()  -- Necessary because cannot start using the sword again from spin attack state.
          assert_equal(hero:get_state(), "free")

          game:simulate_command_pressed("attack")
          hero:start_attack_loading(-1)
          assert_equal(hero:get_state(), "sword loading")
          sol.timer.start(map, 2000, function()
            game:simulate_command_released("attack")
            later(function()
              assert_equal(hero:get_state(), "free")
              sol.main.exit()
            end)
          end)
        end)
      end)
    end)
  end)
end
