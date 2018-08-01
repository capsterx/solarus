local map = ...
local game = map:get_game()

custom_entity:set_traversable_by(false)

function map:on_opening_transition_finished()

  -- Lift the pot.
  assert_equal(game:get_command_effect("action"), "lift")
  game:simulate_command_pressed("action")
  assert_equal(game:get_command_effect("action"), "throw")
end

function pot:on_lifting(carrier, carried_object)

  assert_equal(carrier, hero)
  assert_equal(carried_object:get_type(), "carried_object")
  local sprite = carried_object:get_sprite()
  assert(sprite ~= nil)
  assert_equal(sprite:get_animation_set(), "entities/pot")

  -- Throw the pot.
  sol.timer.start(map, 1000, function()
    assert_equal(game:get_command_effect("action"), "throw")
    game:simulate_command_pressed("action")
    assert_equal(game:get_command_effect("action"), nil)
    game:set_ability("lift", 1)
    custom_entity:set_weight(1)
    game:simulate_command_pressed("down")
    sol.timer.start(map, 100, function()
      game:simulate_command_released("down")
    end)
  end)

  function carried_object:on_removed()
    -- Lift the custom entity.
    assert_equal(game:get_command_effect("action"), "lift")
    game:simulate_command_pressed("action")
    assert_equal(game:get_command_effect("action"), "throw")
  end

end

function custom_entity:on_lifting(carrier, carried_object)

  assert_equal(carrier, hero)
  assert_equal(carried_object:get_type(), "carried_object")
  local sprite = carried_object:get_sprite()
  assert(sprite ~= nil)
  assert_equal(sprite:get_animation_set(), "16x16")

  -- Throw the custom entity.
  sol.timer.start(map, 1000, function()
    assert_equal(game:get_command_effect("action"), "throw")
    game:simulate_command_pressed("action")
    assert_equal(game:get_command_effect("action"), nil)
  end)

  function carried_object:on_removed()
    sol.main.exit()
  end

end
