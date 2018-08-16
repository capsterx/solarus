local map = ...
local game = map:get_game()

function map:on_started()

  assert(enabled_block:is_enabled())
  assert(not disabled_block:is_enabled())
end

function map:on_opening_transition_finished()

  assert(enabled_block:is_enabled())
  assert(not disabled_block:is_enabled())
  sol.main.exit()
end
