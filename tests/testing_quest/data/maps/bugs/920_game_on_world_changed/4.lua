local map = ...
local game = map:get_game()

function game:on_world_changed(previous_world, new_world)

  assert_equal(previous_world, "a")
  assert_equal(new_world, "b")

  sol.main.exit()
end
