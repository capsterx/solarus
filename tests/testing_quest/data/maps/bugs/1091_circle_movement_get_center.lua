local map = ...
local game = map:get_game()

function map:on_started()

  local movement = sol.movement.create("circle")
  movement:set_radius(100)

  movement:set_center(42, 64)
  local x, y = movement:get_center()
  assert_equal(x, 42)
  assert_equal(y, 64)

  movement:set_center(hero, 16, 8)
  x, y = movement:get_center()
  local hero_x, hero_y = hero:get_position()
  assert_equal(x, hero_x + 16)
  assert_equal(y, hero_y + 8)
  sol.main.exit()
end
