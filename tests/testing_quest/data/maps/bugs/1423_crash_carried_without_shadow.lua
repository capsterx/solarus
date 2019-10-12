local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  game:simulate_command_pressed("action")
  assert_equal(hero:get_state(), "lifting")
    
  local carried_object = hero:get_carried_object()
  assert(carried_object ~= nil)
  local shadow = carried_object:get_sprite("shadow")
  assert(shadow ~= nil)
  shadow:stop_animation()
  carried_object:remove_sprite(shadow)
  
  assert(carried_object:get_sprite("shadow") == nil)

  function carried_object:on_lifted()
    local shadow = carried_object:get_sprite("shadow")    
    assert(shadow == nil)
  end

  sol.timer.start(map, 500, function()
    game:simulate_command_pressed("left")  -- Start moving: it should not crash.
    sol.timer.start(map, 500, sol.main.exit)
  end)
end
