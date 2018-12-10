local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local hero_x, hero_y = hero:get_position()
  local xy = { x = hero_x, y = hero_y }

  local movement = sol.movement.create("straight")
  movement:set_angle(math.pi)
  movement:set_max_distance(96)
  movement:set_speed(96)

  function movement:on_position_changed(x, y)
    hero:set_position(x, y)
  end

  movement:start(xy, function()
    local initial_x, initial_y = destination:get_position()
    local hero_x, hero_y = hero:get_position()
    assert_equal(hero_y, initial_y)
    assert_equal(hero_x, initial_x - 96)
    sol.main.exit()
  end)
end
