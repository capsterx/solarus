local map = ...
local game = map:get_game()

function map:on_started()

  local fonts = sol.main.get_resource_ids("font")
  assert_equal(#fonts, 2)
  assert_equal(fonts[1], "8_bit")
  assert_equal(fonts[2], "enter_command")

  assert(sol.main.resource_exists("font", "8_bit"))
  assert(not sol.main.resource_exists("font", "comic_sans"))  -- Thank god.
  assert_equal(sol.main.get_resource_description("font", "8_bit"), "8 bit")

  sol.main.add_resource("font", "comic_sans")
  assert(sol.main.resource_exists("font", "comic_sans"))
  assert_equal(sol.main.get_resource_description("font", "comic_sans"), nil)
  fonts = sol.main.get_resource_ids("font")
  assert_equal(#fonts, 3)

  sol.main.remove_resource("font", "comic_sans")
  assert(not sol.main.resource_exists("font", "comic_sans"))
  fonts = sol.main.get_resource_ids("font")
  assert_equal(#fonts, 2)

  sol.main.add_resource("font", "another_one", "Description")
  assert(sol.main.resource_exists("font", "another_one"))
  assert_equal(sol.main.get_resource_description("font", "another_one"), "Description")
  sol.main.exit()
end
