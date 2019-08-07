local map = ...

function map:on_opening_transition_finished()

  local count = 0
  for block in map:get_entities_by_type("block") do
    local expected_in_obstacle = block:get_property("expected_in_obstacle") == "true"
    assert_equal(block:test_obstacles(), expected_in_obstacle)
    count = count + 1
  end
  assert(count > 0)
  sol.main.exit()
end
