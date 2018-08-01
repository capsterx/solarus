local map = ...
local game = map:get_game()

local trajectory = {
  { 0, 1 },
  { 0, 1 },
  { 0, 1 },
  { 0, 1 },
  { 1, 0 },
  { 1, 0 },
}

local path = {
  0,
  3,
  3,
  1,
}

function map:on_started()

  local pixel_movement = sol.movement.create("pixel")
  pixel_movement:set_trajectory(trajectory)
  local actual_trajectory = pixel_movement:get_trajectory()
  assert_equal(#actual_trajectory, #trajectory)
  for i = 1, #trajectory do
    assert_equal(actual_trajectory[i][1], trajectory[i][1])
    assert_equal(actual_trajectory[i][2], trajectory[i][2])
  end

  local path_movement = sol.movement.create("path")
  path_movement:set_path(path)
  local actual_path = path_movement:get_path()
  assert_equal(#actual_path, #path)
  for i = 1, #path do
    assert_equal(actual_path[i], path[i])
  end

  sol.main.exit()
end
