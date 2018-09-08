local map = ...
local game = map:get_game()

local index = 1
local expected_values = {
  false,  -- opening transition finished
  true,   -- game:set_suspended(true)
  false   -- game:set_suspended(false)
}

function hero:on_suspended(suspended)

  assert_equal(suspended, expected_values[index])
  index = index + 1
  if index > #expected_values then
    sol.main.exit()
  end
end

function map:on_opening_transition_finished()

  game:set_suspended(true)
  local timer = sol.timer.start(map, 100, function()
    game:set_suspended(false)
  end)
  timer:set_suspended_with_map(false)
end
