local map = ...
local game = map:get_game()

function map:on_started()
  game:set_ability("swim", 1)
end

function map:on_opening_transition_finished()
  assert_equal(game:get_command_effect("action"), "look")
  game:simulate_command_pressed("action")
end

function sign:on_interaction()
  game:simulate_command_pressed("right")
  sol.timer.start(map, 200, function()
    assert_equal(game:get_command_effect("action"), "swim")
    sol.main.exit()
  end)
end
