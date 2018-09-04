local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  sol.timer.start(map, 500, function()
    local hero_x, hero_y = hero:get_position()
    local expected_x, expected_y = destination:get_position()
    assert_equal(hero_x, expected_x)
    assert_equal(hero_y, expected_y)
    sol.main.exit()
  end)
end

function teletransporter:on_activated()
  -- This should cancel the teletransportation.
  teletransporter:set_enabled(false)
end
