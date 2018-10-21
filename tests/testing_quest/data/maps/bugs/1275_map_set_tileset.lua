local map = ...
local game = map:get_game()
local expected_color

function map:on_opening_transition_finished()

  map:set_tileset("castle_grayscale")
  expected_color = { 65, 65, 65 }
end

function map:on_draw(dst_surface)

  if expected_color == nil then
    return
  end

  local pixels = dst_surface:get_pixels()
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)
  sol.main.exit()
end
