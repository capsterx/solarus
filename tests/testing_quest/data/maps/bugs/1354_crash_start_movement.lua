local map = ...

function hero:on_state_changed(state)

  if state == "free" then
    local movement = sol.movement.create("straight")
    movement:set_speed(88)
    movement:set_angle(0)
    movement:set_max_distance(32)
    movement:start(hero, function()
      local hero_x, hero_y = hero:get_position()
      local target_x, target_y = target_sensor:get_position()
      assert_equal(hero_x, target_x)
      assert_equal(hero_y, target_y)
      sol.main.exit()
    end)
  end
end
