local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  assert_equal(hero:get_state(), "free")
  game:simulate_command_pressed("action")
  assert_equal(hero:get_state(), "lifting")
  sol.timer.start(map, 1000, function()
    -- Vase sprite with 4 directions.
    local vase = hero:get_carried_object()
    assert(vase ~= nil)
    local vase_sprite = vase:get_sprite()
    assert_equal(hero:get_sprite():get_direction(), 3)
    assert_equal(vase_sprite:get_direction(), 3)
    assert_equal(hero:get_sprite():get_direction(), 3)
    -- Turn the hero and check that the carried object takes the new direction.
    game:simulate_command_pressed("left")
    sol.timer.start(map, 10, function()
      game:simulate_command_released("left")
      assert_equal(hero:get_sprite():get_direction(), 2)
      assert_equal(vase_sprite:get_direction(), 2)
      game:simulate_command_pressed("action")  -- Throw the carried object.
      assert_equal(hero:get_state(), "free")
      game:simulate_command_pressed("action")
      assert_equal(hero:get_state(), "lifting")
      sol.timer.start(map, 1000, function()
        -- Vase sprite with 1 direction.
        local vase = hero:get_carried_object()
        assert(vase ~= nil)
        local vase_sprite = vase:get_sprite()
        assert_equal(vase_sprite:get_direction(), 0)
        sol.main.exit()
      end)
    end)
  end)
  
end
