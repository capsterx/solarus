local map = ...
local game = map:get_game()

function map:on_started()

  sol.timer.start(sol.main, 10, function()
    map:get_ground(42, 24, 0)
    map:get_hero()
    return true
  end)
end
