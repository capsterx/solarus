local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  assert(door:is_closed())
  door:open()
  assert(door:is_open())
  door:close()
  assert(not door:is_open())
  door:set_open(true)
  assert(door:is_open())
  door:set_open(false)
  assert(not door:is_open())

  sol.main.exit()
end
