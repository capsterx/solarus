local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  assert_equal(default_dying_animation_enemy:get_dying_sprite_id(), "enemies/enemy_killed")
  default_dying_animation_enemy:set_life(0)

  assert_equal(explosion_enemy:get_dying_sprite_id(), "enemies/enemy_killed")
  explosion_enemy:set_dying_sprite_id("entities/explosion")
  assert_equal(explosion_enemy:get_dying_sprite_id(), "entities/explosion")
  explosion_enemy:set_life(0)

  assert_equal(no_dying_animation_enemy:get_dying_sprite_id(), "enemies/enemy_killed")
  no_dying_animation_enemy:set_dying_sprite_id(nil)
  assert_equal(no_dying_animation_enemy:get_dying_sprite_id(), nil)
  no_dying_animation_enemy:set_life(0)

  sol.timer.start(map, 50, function()
    assert_equal(default_dying_animation_enemy:get_sprite():get_animation_set(), "enemies/enemy_killed")
    assert_equal(explosion_enemy:get_sprite():get_animation_set(), "entities/explosion")
    assert_equal(no_dying_animation_enemy, nil)
  end)

  sol.timer.start(map, 2000, function()
    assert_equal(default_dying_animation_enemy, nil)
    assert_equal(explosion_enemy, nil)
    sol.main.exit()
  end)
end
