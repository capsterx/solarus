local map = ...
local game = map:get_game()

function game:on_world_changed(previous_world, new_world)

  assert_equal(previous_world, nil)
  assert_equal(new_world, "a")

  sol.timer.start(game, 1000, function()
    hero:teleport("bugs/920_game_on_world_changed/3")
  end)
end
