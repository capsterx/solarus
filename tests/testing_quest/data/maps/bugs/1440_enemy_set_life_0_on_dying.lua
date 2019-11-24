local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  function enemy:on_dying()
    sol.main.exit()
  end
  enemy:set_life(0)
end
