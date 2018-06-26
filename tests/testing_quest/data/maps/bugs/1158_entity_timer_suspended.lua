local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  assert(not game:is_suspended())

  local robyne_timer_suspend = sol.timer.start(robyne, 1000, function()
    assert(not game:is_suspended())
    sol.main.exit()
  end)
  robyne_timer_suspend:set_suspended_with_map(true)
  assert(robyne_timer_suspend:is_suspended_with_map())

  local robyne_timer_no_suspend = sol.timer.start(robyne, 1000, function()
  end)
  robyne_timer_no_suspend:set_suspended_with_map(false)
  assert(not robyne_timer_no_suspend:is_suspended_with_map())

  local map_timer_1 = sol.timer.start(map, 500, function()
    assert(game:is_suspended())
    assert(robyne_timer_suspend:is_suspended())
    assert(not robyne_timer_no_suspend:is_suspended())
  end)
  map_timer_1:set_suspended_with_map(false)
  assert(not map_timer_1:is_suspended_with_map())

  local map_timer_2 = sol.timer.start(map, 2000, function()
    assert(game:is_suspended())
    game:set_paused(false)
  end)
  map_timer_2:set_suspended_with_map(false)
  assert(not map_timer_1:is_suspended_with_map())

  game:set_paused(true)
end
