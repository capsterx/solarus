local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  game:simulate_command_pressed("action")
  sol.timer.start(map, 1000, function()
    -- Throw the vase.
    game:simulate_command_pressed("action")
  end)
end

function hero:on_state_changed(state)

  if state == "carrying" then
    local carried_object = hero:get_carried_object()
    function carried_object:on_thrown()
      carried_object:get_movement():stop()
      sol.timer.start(map, 2000, sol.main.exit)
    end
  end

end
