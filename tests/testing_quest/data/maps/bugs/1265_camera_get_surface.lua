local map = ...
local game = map:get_game()
local expected_color

function map:on_opening_transition_finished()
  expected_color = { 0, 0, 255 }
end

function custom:on_pre_draw(camera)
  assert_equal(sol.main.get_type(camera), "camera")
end

function custom:on_post_draw(camera)

  assert_equal(sol.main.get_type(camera), "camera")

  if expected_color == nil then
    return
  end

  local surface = camera:get_surface()
  assert_equal(sol.main.get_type(surface), "surface")
  surface:fill_color(expected_color, custom:get_bounding_box())
end

function map:on_draw(dst_surface)

  if expected_color == nil then
    return
  end

  local pixels = dst_surface:get_pixels()
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)
  sol.main.exit()
end
