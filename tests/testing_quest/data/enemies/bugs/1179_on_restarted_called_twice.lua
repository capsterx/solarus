
local enemy = ...
local game = enemy:get_game()

local count = 0

function enemy:on_restarted()

  count = count + 1
end

function enemy:get_on_restarted_count()
  return count
end
