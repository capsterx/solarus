local map = ...
local game = map:get_game()
local movement

north_detector:add_collision_test("overlapping", function(detector, entity)
  if entity ~= robyne then
    return
  end
  assert_equal(movement:get_direction4(), 2)
  north_detector.detected_robyne = true
end)

west_detector:add_collision_test("overlapping", function(detector, entity)
  if entity ~= robyne then
    return
  end
  assert_equal(movement:get_direction4(), 3)
  west_detector.detected_robyne = true
end)

south_detector:add_collision_test("overlapping", function(detector, entity)
  if entity ~= robyne then
    return
  end
  assert_equal(movement:get_direction4(), 0)
  south_detector.detected_robyne = true
end)

east_detector:add_collision_test("overlapping", function(detector, entity)
  if entity ~= robyne then
    return
  end
  assert_equal(movement:get_direction4(), 1)
  east_detector.detected_robyne = true
end)

function map:on_started()

  movement = sol.movement.create("circle")
  movement:set_center(center)
  movement:set_radius(center:get_distance(robyne))
  movement:start(robyne)

  sol.timer.start(map, 3000, function()
    assert(north_detector.detected_robyne)
    assert(west_detector.detected_robyne)
    assert(north_detector.detected_robyne)
    assert(south_detector.detected_robyne)
    sol.main.exit()
  end)
end
