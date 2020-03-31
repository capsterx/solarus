local map = ...
local game = map:get_game()

function map:on_started()

  ladder:set_modified_ground("ladder")
end

function map:on_opening_transition_finished()

  local ground_sprite = hero:get_sprite("ground")
  assert(ground_sprite ~= nil)
  assert_equal(ground_sprite:is_animation_started(), true)

  local movement = sol.movement.create("straight")
  movement:set_angle(0)
  movement:set_speed(88)
  movement:start(hero)
end

function sensor:on_activated()
  hero:stop_movement()
  local ground_sprite = hero:get_sprite("ground")
  assert(ground_sprite == nil)
  sol.main.exit()
end
