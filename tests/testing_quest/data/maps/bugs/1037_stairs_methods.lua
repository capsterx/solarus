local map = ...
local game = map:get_game()

function map:on_started()

  for stairs in map:get_entities("inner_stairs") do
    assert(stairs:is_inner())
    assert_equal(stairs:get_direction(), tonumber(stairs:get_property("expected_direction")))
  end
  for stairs in map:get_entities("outer_stairs") do
    assert(not stairs:is_inner())
    assert_equal(stairs:get_direction(), tonumber(stairs:get_property("expected_direction")))
  end

  sol.main.exit()
end
