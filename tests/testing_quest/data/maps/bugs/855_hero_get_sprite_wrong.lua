local map = ...

function map:on_started()

  local sprite_before = hero:get_sprite()
  assert(sprite_before == hero:get_sprite("tunic"))
  assert(sprite_before:get_animation_set() == "hero/tunic1")

  hero:set_tunic_sprite_id("hero/robyne_tunic")
  local sprite_after = hero:get_sprite()
  assert(sprite_after ~= sprite_before)
  assert(sprite_after == hero:get_sprite("tunic"))
  assert(sprite_after:get_animation_set() == "hero/robyne_tunic")

  sol.main.exit()
end
