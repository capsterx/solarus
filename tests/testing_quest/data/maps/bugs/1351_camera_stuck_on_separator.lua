local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local camera = map:get_camera()
  
  assert_equal(camera:test_obstacles(0, 0), false)
  assert_equal(camera:test_obstacles(32, 0), true)
  assert_equal(camera:test_obstacles(1, 0), true)
  assert_equal(camera:test_obstacles(0, 1), false)
  assert_equal(camera:test_obstacles(319, 0), true)
  assert_equal(camera:test_obstacles(320, 0), false)
  assert_equal(camera:test_obstacles(320, 1), true)
  assert_equal(camera:test_obstacles(320, 239), true)
  assert_equal(camera:test_obstacles(320, 240), false)
  
  local movement = sol.movement.create("straight")
  movement:set_speed(192)
  movement:set_angle(3 * math.pi / 2)
  movement:set_max_distance(32)
  movement:start(camera, sol.main.exit)
end
