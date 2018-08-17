local map = ...
local game = map:get_game()

platform:set_modified_ground("traversable")
platform_2:set_modified_ground("traversable")

function map:on_started()

  local x, y = platform:get_position()
  local top_left_x, top_left_y, width, height = platform:get_bounding_box()
  local origin_x, origin_y = platform:get_origin()
  assert_equal(x, 56)
  assert_equal(y, 29)
  assert_equal(top_left_x, 48)
  assert_equal(top_left_y, 16)
  assert_equal(width, 32)
  assert_equal(height, 32)

  x, y = platform_2:get_position()
  top_left_x, top_left_y, width, height = platform_2:get_bounding_box()
  origin_x, origin_y = platform_2:get_origin()

  assert_equal(x, 64)
  assert_equal(y, 96)
  assert_equal(top_left_x, 48)
  assert_equal(top_left_y, 80)
  assert_equal(width, 32)
  assert_equal(height, 32)
end

function map:on_opening_transition_finished()

  local x, y = platform:get_position()
  local top_left_x, top_left_y, width, height = platform:get_bounding_box()
  local origin_x, origin_y = platform:get_origin()
  assert_equal(x, 56)
  assert_equal(y, 29)
  assert_equal(top_left_x, 48)
  assert_equal(top_left_y, 16)
  assert_equal(width, 32)
  assert_equal(height, 32)

  platform:set_origin(16, 16)

  x, y = platform:get_position()
  top_left_x, top_left_y, width, height = platform:get_bounding_box()
  origin_x, origin_y = platform:get_origin()
  assert_equal(x, 56)
  assert_equal(y, 29)
  assert_equal(top_left_x, 40)
  assert_equal(top_left_y, 13)
  assert_equal(width, 32)
  assert_equal(height, 32)

  platform:set_position(64, 32)

  x, y = platform:get_position()
  top_left_x, top_left_y, width, height = platform:get_bounding_box()
  origin_x, origin_y = platform:get_origin()

  assert_equal(x, 64)
  assert_equal(y, 32)
  assert_equal(top_left_x, 48)
  assert_equal(top_left_y, 16)
  assert_equal(width, 32)
  assert_equal(height, 32)

  x, y = platform_2:get_position()
  top_left_x, top_left_y, width, height = platform_2:get_bounding_box()
  origin_x, origin_y = platform_2:get_origin()

  assert_equal(x, 64)
  assert_equal(y, 96)
  assert_equal(top_left_x, 48)
  assert_equal(top_left_y, 80)
  assert_equal(width, 32)
  assert_equal(height, 32)

  sol.main.exit()
end
