local map = ...
local game = map:get_game()
local expected_color

function map:on_started()

  custom:set_draw_override(function(entity, camera)
    if expected_color ~= nil then
      camera:get_surface():fill_color(expected_color, entity:get_bounding_box())
    end
  end)
end

function map:on_opening_transition_finished()
  expected_color = { 0, 0, 255 }
end

function map:on_draw(dst_surface)

  if expected_color == nil then
    return
  end

  local pixels = dst_surface:get_pixels()
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)
  sol.main.exit()
end
