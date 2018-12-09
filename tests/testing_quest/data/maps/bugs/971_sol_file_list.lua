local map = ...
local game = map:get_game()

function map:on_started()

  -- Non-empty directory.
  assert(sol.file.is_dir("fonts"))
  local files = sol.file.list_dir("fonts")
  assert_equal(type(files), "table")
  assert_equal(#files, 2)
  assert_equal(files[1], "8_bit.png")
  assert_equal(files[2], "enter_command.ttf")

  -- Empty directory.
  assert(not sol.file.exists("971_empty"))
  sol.file.mkdir("971_empty")
  assert(sol.file.exists("971_empty"))
  assert(sol.file.is_dir("971_empty"))
  files = sol.file.list_dir("971_empty")
  assert_equal(type(files), "table")
  assert_equal(#files, 0)
  sol.file.remove("971_empty")
  assert(not sol.file.exists("971_empty"))

  -- Not a directory.
  assert(not sol.file.exists("971_not_a_dir"))
  local f = sol.file.open("971_not_a_dir", "w")
  f:write("hello")
  f:close()
  assert(sol.file.exists("971_not_a_dir"))
  assert(not sol.file.is_dir("971_not_a_dir"))
  f = sol.file.open("971_not_a_dir")
  assert_equal(f:read("*a"), "hello")
  files = sol.file.list_dir("971_not_a_dir")
  assert(files == nil)
  sol.file.remove("971_not_a_dir")
  assert(not sol.file.exists("971971_not_a_dir"))

  -- Non existing directory.
  assert(not sol.file.exists("does_not_exist"))
  assert(not sol.file.is_dir("does_not_exist"))
  files = sol.file.list_dir("does_not_exist")
  assert(files == nil)

  sol.main.exit()
end
