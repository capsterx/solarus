local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()
  -- test if current hero state events have been called

  -- TODO not working yet because the engine goes to free state automatically
  -- add state:get/set_persist_accross_maps?
  -- assert_equal(hero:get_state(), "custom")
  -- hero:get_state_object():collect_events()
  sol.main.exit()
end
