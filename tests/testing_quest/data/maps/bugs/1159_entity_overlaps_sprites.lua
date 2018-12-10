local map = ...
local game = map:get_game()

game:set_ability("sword", 1)

function map:on_opening_transition_finished()

  -- Give two sprites to the custom entity: a main one and a shadow.
  -- The sword sprite of the hero will overlap the main one but not the shadow. 

  local custom_main_sprite = custom:get_sprite()
  assert(custom_main_sprite ~= nil)
  local custom_shadow_sprite = custom:create_sprite("entities/shadow")
  assert(custom_shadow_sprite ~= nil)
  custom_shadow_sprite:set_animation("small")

  game:simulate_command_pressed("attack")
  sol.timer.start(map, 500, function()
    assert(not hero:overlaps(custom))
    assert(not hero:overlaps(custom, overlapping))
    assert(hero:overlaps(custom, "sprite"))

    local tunic_sprite = hero:get_sprite("tunic")
    assert(tunic_sprite ~= nil)
    local sword_sprite = hero:get_sprite("sword")
    assert(sword_sprite ~= nil)

    assert(not hero:overlaps(custom, "sprite", tunic_sprite, custom_main_sprite))
    assert(not hero:overlaps(custom, "sprite", tunic_sprite, custom_shadow_sprite))
    assert(hero:overlaps(custom, "sprite", sword_sprite, custom_main_sprite))
    assert(not hero:overlaps(custom, "sprite", sword_sprite, custom_shadow_sprite))

    assert(not hero:overlaps(custom, "sprite", tunic_sprite, nil))
    assert(not hero:overlaps(custom, "sprite", tunic_sprite))
    assert(hero:overlaps(custom, "sprite", sword_sprite, nil))
    assert(hero:overlaps(custom, "sprite", sword_sprite))
    assert(hero:overlaps(custom, "sprite", nil, custom_main_sprite))
    assert(not hero:overlaps(custom, "sprite", nil, custom_shadow_sprite))

    sol.main.exit()
  end)
end
