local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  function hero:on_state_changing(state_name, next_state_name)
    assert(state_name == "free")
    assert(next_state_name == "frozen")
    sol.main.exit()
  end

  hero:freeze()
end
