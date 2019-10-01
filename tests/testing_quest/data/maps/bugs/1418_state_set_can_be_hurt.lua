local map = ...
local game = map:get_game()

function map:on_started()
  enemy:set_enabled(false)
end

function map:on_opening_transition_finished()

  assert_equal(hero:get_state(), "free")
  assert_equal(hero:get_state_object(), nil)

  local sprite = hero:get_sprite()
  assert_equal(sprite:get_animation(), "stopped")

  local state = sol.state.create()
  state:set_can_be_hurt(false)
  hero:start_state(state)

  enemy:set_attacking_collision_mode("touching")
  enemy:set_enabled(true)
  assert_equal(enemy:overlaps(hero, "touching"), true)

  sol.timer.start(map, 100, function()
    assert_equal(hero:get_state(), "custom")  -- The hero should not be hurt.
    assert_equal(hero:get_state_object(), state)
    local sprite = hero:get_sprite()
    assert_equal(sprite:get_animation(), "stopped")
    sol.main.exit()
  end)
end
