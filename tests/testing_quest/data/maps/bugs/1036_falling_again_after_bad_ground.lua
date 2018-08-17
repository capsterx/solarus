local map = ...
local game = map:get_game()

function map:on_started()

  platform:set_modified_ground("traversable")
  hero:save_solid_ground(function()
    return solid_ground_marker:get_position()
  end)
end

function map:on_opening_transition_finished()

  game:simulate_command_pressed("right")
  sol.timer.start(map, 3000, function()
    local hero_x, hero_y = hero:get_position()
    local target_x, target_y = solid_ground_marker:get_position()
    assert_equal(hero_x, target_x)
    assert_equal(hero_y, target_y)
    sol.main.exit()
  end)
end

function hero:on_state_changed(state)

  if state == "falling" then
    game:simulate_command_released("right")
  end
end
