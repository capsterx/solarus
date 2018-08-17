local map = ...
local game = map:get_game()
local super_spin_attack_ability_used = false
local sword = game:get_item("sword")

game:set_ability("sword", 1)
game:set_ability("sword_knowledge", 1)

function sword:on_ability_used(ability)

  if ability == "sword_knowledge" then
    super_spin_attack_ability_used = true
  end
end

function map:on_opening_transition_finished()

  game:simulate_command_pressed("attack")
  sol.timer.start(map, 2000, function()
    game:simulate_command_released("attack")

    sol.timer.start(map, 100, function()
      assert(super_spin_attack_ability_used)
      sol.main.exit()
    end)
  end)
end
