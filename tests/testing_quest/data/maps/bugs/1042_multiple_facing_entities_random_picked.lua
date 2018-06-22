local map = ...
local game = map:get_game()

function map:on_started()

  -- Make the hero face a lot of blocks at identical positions.
  -- The block that wins must be the bottom one.
  for block in map:get_entities("block_") do
    block:set_position(block_1:get_position())
  end

  -- Bring to the back a block that was initially in the middle if the pack,
  -- so that its pointer value is probably not to the lowest one of all blocks.
  block_10:bring_to_back()
end

function map:on_opening_transition_finished()
  local facing_entity = hero:get_facing_entity()
  assert_equal(facing_entity:get_name(), "block_10")
  assert(facing_entity == block_10)
  sol.main.exit()
end
 