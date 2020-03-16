local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()
  
  local state = sol.state.create()
  state:set_can_control_movement(false)
  state:set_can_control_direction(false)
  state:set_can_push(false)
  function state:on_started()
    local movement = sol.movement.create("straight")
    movement:set_angle(math.pi)
    movement:start(hero)
  end
  hero:start_state(state)
end

function teletransporter:on_activated()
  sol.main.exit()
end
