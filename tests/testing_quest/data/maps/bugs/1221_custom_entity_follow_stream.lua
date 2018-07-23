local map = ...
local game = map:get_game()

following_entity:set_follow_streams(true)

function map:on_opening_transition_finished()

  sol.timer.start(map, 10, function()
    assert(initial_stream ~= nil)
    assert(following_entity:get_controlling_stream() == initial_stream)
    assert(not_following_entity:get_controlling_stream() == nil)
  end)

  sol.timer.start(map, 4000, function()
    local x, y = following_entity:get_position()
    local final_x, final_y = final_place:get_position()
    assert_equal(x, final_x)
    assert_equal(y, final_y)

    x, y = not_following_entity:get_position()
    initial_x, initial_y = initial_stream:get_position()
    assert_equal(x, initial_x)
    assert_equal(y, initial_y)
    sol.main.exit()
  end)
end
