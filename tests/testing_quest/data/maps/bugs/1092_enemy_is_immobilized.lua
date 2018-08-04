local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  assert(not enemy:is_immobilized())
  enemy:immobilize()
  assert(enemy:is_immobilized())

  sol.timer.start(map, 10000, function()
    assert(not enemy:is_immobilized())
    sol.main.exit()
  end)
end
