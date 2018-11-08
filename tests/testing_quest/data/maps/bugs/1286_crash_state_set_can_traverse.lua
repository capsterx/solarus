local map = ...
local game = map:get_game()

function map:on_started()

  local state = sol.state.create()
  state:set_can_traverse("stairs", false)
  sol.main.exit()
end
