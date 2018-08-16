local map = ...
local game = map:get_game()

function game:on_world_changed(previous_world, new_world)

  if not game.second_run then
    assert_equal(previous_world, "a")
    assert_equal(new_world, "b")
  else
    -- Restarting the game on this same map.
    assert_equal(previous_world, nil)
    assert_equal(new_world, "b")
    sol.main.exit()
  end
end

function map:on_opening_transition_finished()

  game.second_run = true
  game:start()
  end
