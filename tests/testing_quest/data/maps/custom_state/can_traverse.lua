local map = ...
local game = map:get_game()

local defaults = {
  npc = false,
  block = false,
  sensor = true,
}

function map:on_opening_transition_finished()
  local state = sol.state.create()
  hero:start_state(state)

  for entity_type, traversable in pairs(defaults) do

    local entity = map:get_entity(entity_type)  -- Named from the type.
    hero:set_position(entity:get_position())
    assert_equal(hero:get_state(), "custom")
    assert_equal(hero:get_state_object(), state)

    assert_equal(hero:test_obstacles(), not traversable)

    state:set_can_traverse(entity_type, true)
    assert_equal(hero:test_obstacles(), false)

    state:set_can_traverse(entity_type, false)
    assert_equal(hero:test_obstacles(), true)
  end

  sol.main.exit()
end
