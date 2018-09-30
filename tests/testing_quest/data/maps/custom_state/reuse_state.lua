local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local state = sol.state.create()
  hero:start_state(state)
  sol.timer.start(map, 100, function()
    hero:unfreeze()
    sol.timer.start(map, 100, function()
      hero:start_state(state)
      sol.timer.start(map, 100, sol.main.exit)
    end)
  end)
end
