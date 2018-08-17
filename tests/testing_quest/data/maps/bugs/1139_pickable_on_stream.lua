local map = ...
local game = map:get_game()

function map:on_started()

  sol.timer.start(map, 4000, function()
    local x, y = bomb:get_position()
    local final_x, final_y = final_place:get_position()
    assert_equal(x, final_x)
    assert_equal(y, final_y)
    sol.main.exit()
  end)
end