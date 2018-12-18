local map = ...
local game = map:get_game()

local expected_color

function map:on_started()

  -- Test an entity with multiple sprites.
  local sprite_2 = block:create_sprite("16x16")
  local num_sprites = 0
  local main_sprite = block:get_sprite()
  assert(main_sprite ~= nil)
  assert(main_sprite ~= sprite_2)
  assert(main_sprite:get_animation_set() == "blocks/block_brown")

  for sprite_name, sprite in block:get_sprites() do
    num_sprites = num_sprites + 1
    if num_sprites == 1 then
      assert_equal(sprite_name, "")
      assert_equal(sprite, main_sprite)
      assert_equal(sprite:get_animation_set(), "blocks/block_brown")
    elseif num_sprites == 2 then
      assert_equal(sprite_name, "")
      assert_equal(sprite, sprite_2)
      assert_equal(sprite:get_animation_set(), "16x16")
    end
  end
  assert(num_sprites == 2)

  -- Test with the hero.
  local created_sprite = hero:create_sprite("16x16", "additional_sprite")
  local main_sprite = hero:get_sprite()
  assert(main_sprite ~= nil)
  assert_equal(main_sprite:get_animation_set(), "hero/tunic1")

  local sprite = hero:get_sprite("additional_sprite")
  assert_equal(sprite, created_sprite)
  assert_equal(sprite:get_animation_set(), "16x16")

end

function map:on_opening_transition_finished()
  expected_color = { 255, 0, 255 }
end

function map:on_draw(dst_surface)

  if expected_color == nil then
    return
  end

  local pixels = dst_surface:get_pixels()
  print(pixels:byte(1,3))
  print(unpack(expected_color))
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)

  local sprite = hero:get_sprite("additional_sprite")
  hero:remove_sprite(sprite)
  sprite = hero:get_sprite("additional_sprite")
  assert_equal(sprite, nil)

  sol.main.exit()
end
