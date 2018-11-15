local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()
  assert_equal(dynamic_tile, nil)  -- This dynamic tile should not have been created.
  sol.main.exit()
end
