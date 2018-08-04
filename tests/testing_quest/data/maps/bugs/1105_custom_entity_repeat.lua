local map = ...
local game = map:get_game()

function map:on_started()

  tiled_entity:set_tiled(true)
  assert(tiled_entity:is_tiled())

  assert(not non_tiled_entity:is_tiled())
  non_tiled_entity:set_tiled(true)
  assert(non_tiled_entity:is_tiled())

  sol.main.exit()
end
