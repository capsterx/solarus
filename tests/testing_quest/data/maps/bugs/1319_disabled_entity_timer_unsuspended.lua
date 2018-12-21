local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  block:set_enabled(false)
  local timer = sol.timer.start(block, 1000, function()
    assert(false)
  end)

  assert(timer:is_suspended())
  game:set_paused(true)
  assert(timer:is_suspended())
  later(function()
    game:set_paused(false)
    assert(timer:is_suspended())
  end)

  sol.timer.start(map, 2000, sol.main.exit)
end
