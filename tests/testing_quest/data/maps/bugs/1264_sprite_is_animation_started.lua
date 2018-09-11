local map = ...
local game = map:get_game()

local expected_color

function map:on_opening_transition_finished()

  assert(hero:get_sprite():is_animation_started())

  expected_color = { 255, 0, 255 }  -- Sprite color.

  sol.timer.start(map, 100, function()
    local sprite = custom:get_sprite()
    assert(sprite:is_animation_started())
    sprite:stop_animation()
    assert(not sprite:is_animation_started())

    expected_color = { 33, 89, 52 }  -- Green background.
    sol.timer.start(map, 100, sol.main.exit)
  end)
end

function map:on_draw(dst_surface)

  if expected_color == nil then
    return
  end

  local pixels = dst_surface:get_pixels()
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)
end
