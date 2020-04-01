local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local ground_sprite = hero:get_sprite("ground")
  assert(ground_sprite ~= nil)
  assert_equal(ground_sprite:is_animation_started(), true)

  hero:start_jumping(0, 64)
end

function sensor:on_activated()
  -- Still above shallow water, but jumping.
  local state = hero:get_state()
  assert_equal(state, "jumping")
  local ground_sprite = hero:get_sprite("ground")
  assert(ground_sprite == nil)
end

function sensor_2:on_activated()
  -- Still on shallow water, no longer jumping.
  sol.timer.start(map, 100, function()
    local state = hero:get_state()
    assert_equal(state, "free")
    local ground_sprite = hero:get_sprite("ground")
    assert(ground_sprite ~= nil)
    assert_equal(ground_sprite:is_animation_started(), true)
    sol.main.exit()
  end)
end
