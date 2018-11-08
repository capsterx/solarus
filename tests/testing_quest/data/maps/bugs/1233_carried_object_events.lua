local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  -- Lift the pot.
  assert_equal(hero:get_carried_object(), nil)
  assert_equal(game:get_command_effect("action"), "lift")
  game:simulate_command_pressed("action")
  assert_equal(game:get_command_effect("action"), "throw")
end

function pot:on_lifting(carrier, carried_object)

  assert_equal(carrier, hero)
  assert_equal(carried_object:get_type(), "carried_object")
  assert_equal(carried_object:get_carrier(), hero)

  function carried_object:on_lifted()
    assert_equal(carried_object, hero:get_carried_object())
    assert_equal(carried_object:get_carrier(), hero)
    assert_equal(game:get_command_effect("action"), "throw")
    game:simulate_command_pressed("action")
    assert_equal(game:get_command_effect("action"), nil)
  end

  function carried_object:on_thrown()
    function carried_object:on_breaking()
      sol.main.exit()
    end
  end
end
