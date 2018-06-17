local map = ...
local game = map:get_game()

function map:on_started()

  local shader = sol.shader.create("sepia")
  assert_equal(shader:get_scaling_factor(), nil)

  shader:set_scaling_factor(2.0)
  assert_equal(shader:get_scaling_factor(), 2.0)

  shader:set_scaling_factor(nil)
  assert_equal(shader:get_scaling_factor(), nil)

  sol.main.exit()
end
