local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  game:simulate_command_pressed("action")
  assert_equal(hero:get_state(), "lifting")
    
  local carried_object = hero:get_carried_object()
  assert(carried_object ~= nil)
  local shadow = carried_object:get_sprite("shadow")
  assert(shadow ~= nil)
  carried_object:remove_sprite(shadow)
  assert(carried_object:get_sprite("shadow") == nil)

  sol.timer.start(map, 1000, function()
    game:simulate_command_pressed("action")
    
    function carried_object:on_position_changed()
      assert(carried_object:get_sprite("shadow") == nil)
    end

    function carried_object:on_removed()
      sol.main.exit()
    end
  end)
end
