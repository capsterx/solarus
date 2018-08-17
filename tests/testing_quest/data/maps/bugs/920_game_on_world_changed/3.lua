local map = ...
local game = map:get_game()

function game:on_world_changed(previous_world, new_world)

  assert(false)  -- The world has not changed here.
end

function map:on_opening_transition_finished()
  hero:teleport("bugs/920_game_on_world_changed/4")
end
