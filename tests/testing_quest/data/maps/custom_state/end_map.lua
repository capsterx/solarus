local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()
  -- test if current hero state events have been called
  hero:get_state_object():collect_events()
  sol.main.exit()
end
