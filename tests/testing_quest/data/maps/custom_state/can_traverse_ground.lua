local map = ...
local game = map:get_game()

local defaults = {
  traversable = true,
  wall = false,
  low_wall = false,
  shallow_water = true,
  deep_water = true,
  hole = true,
  ice = true,
  lava = true,
  ladder = true,
  prickles = true,
}

function map:on_opening_transition_finished()
  local state = sol.state.create()
  state:set_gravity_enabled(false)
  state:set_affected_by_ground("hole", false)
  state:set_affected_by_ground("lava", false)
  state:set_affected_by_ground("prickles", false)
  state:set_affected_by_ground("deep_water", false)
  hero:start_state(state)
  
  for ground, traversable in pairs(defaults) do

    custom:set_modified_ground(ground)
    assert_equal(hero:get_ground_below(), ground)
    assert_equal(hero:get_state(), "custom")
    assert_equal(hero:get_state_object(), state)

    assert_equal(state:get_can_traverse_ground(ground), traversable)
    assert_equal(hero:test_obstacles(), not traversable)

    state:set_can_traverse_ground(ground, true)
    assert_equal(state:get_can_traverse_ground(ground), true)
    assert_equal(hero:test_obstacles(), false)

    state:set_can_traverse_ground(ground, false)
    assert_equal(state:get_can_traverse_ground(ground), false)
    assert_equal(hero:test_obstacles(), true)
  end

  sol.main.exit()
end
