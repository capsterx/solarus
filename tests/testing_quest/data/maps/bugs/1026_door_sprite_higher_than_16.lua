local map = ...
local game = map:get_game()

function map:on_started()

  door:set_drawn_in_y_order(true)
  assert(door:is_drawn_in_y_order())
  sol.main.exit()
end
