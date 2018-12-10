local map = ...
local game = map:get_game()
local state
local expected_color

local function draw_override(state_param, camera)
  assert_equal(sol.main.get_type(state_param), "state")
  assert_equal(sol.main.get_type(camera), "camera")
  assert_equal(state_param, state)
  if expected_color ~= nil then
    camera:get_surface():fill_color(expected_color, state:get_entity():get_bounding_box())
  end
end

function map:on_started()

  state = sol.state.create()
  assert_equal(state:get_draw_override(), nil)
  state:set_draw_override(draw_override)
  assert_equal(state:get_draw_override(), draw_override)

end

function map:on_opening_transition_finished()

  function state:on_pre_draw(camera)
    assert_equal(sol.main.get_type(camera), "camera")
    expected_color = { 0, 0, 255 }
  end
  hero:start_state(state)
end

function map:on_draw(dst_surface)

  if expected_color == nil then
    return
  end

  local pixels = dst_surface:get_pixels()
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)
  sol.main.exit()
end
