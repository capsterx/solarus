local map = ...
local game = map:get_game()
local movement

north_detector:add_collision_test("overlapping", function(detector, entity)
  if entity == robyne then
    north_detector.detected_robyne = true
  end
end)

west_detector:add_collision_test("overlapping", function(detector, entity)
  if entity == robyne then
    west_detector.detected_robyne = true
  end
end)

south_detector:add_collision_test("overlapping", function(detector, entity)
  if entity == robyne then
    south_detector.detected_robyne = true
  end
end)

east_detector:add_collision_test("overlapping", function(detector, entity)
  if entity == robyne then
    east_detector.detected_robyne = true
  end
end)

function map:on_started()

  movement = sol.movement.create("circle")
  movement:set_center(center)
  movement:set_radius(center:get_distance(robyne))
  movement:set_initial_angle(90)
  movement:set_angle_speed(180)

  assert_equal_approx(movement:get_initial_angle(), 90)
  assert_equal_approx(movement:get_angle_from_center(), math.pi / 2)
  assert_equal_approx(movement:get_angle_speed(), 180)
  assert_equal_approx(movement:get_angular_speed(), math.pi)

  movement:set_angle_from_center(3 * math.pi / 2)
  movement:set_angular_speed(math.pi / 2)
  
  assert_equal_approx(movement:get_initial_angle(), 270)
  assert_equal_approx(movement:get_angle_from_center(), 3 * math.pi / 2)
  assert_equal_approx(movement:get_angle_speed(), 90)
  assert_equal_approx(movement:get_angular_speed(), math.pi / 2)

  movement:start(robyne)

  sol.timer.start(map, 6000, function()
    assert(north_detector.detected_robyne)
    assert(west_detector.detected_robyne)
    assert(north_detector.detected_robyne)
    assert(south_detector.detected_robyne)
    sol.main.exit()
  end)
end
