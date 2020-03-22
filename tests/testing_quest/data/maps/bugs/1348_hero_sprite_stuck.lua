local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  local sprite = hero:create_sprite("shatter")
  function sprite:on_frame_changed(frame)
    sol.main.exit()
  end
end
