local map = ...

function map:on_started()

  local sprite_1 = custom:create_sprite("blocks/block_brown")
  local sprite_2 = custom:create_sprite("blocks/block_brown")

  custom:remove_sprite(sprite_2)

  sol.main.exit()
end
