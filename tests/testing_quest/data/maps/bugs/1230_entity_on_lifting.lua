local map = ...
local game = map:get_game()

function pot:on_lifting(carrier, carried_object)

  assert_equal(carrier, hero)
  assert_equal(carried_object:get_type(), "carried_object")
  sol.main.exit()
end

function map:on_opening_transition_finished()

  game:simulate_command_pressed("action")
end
