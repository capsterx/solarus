local map = ...
local game = map:get_game()

local expected_color
local blue = { 0, 0, 255 }
local green = { 0, 255, 0 }

local blue_menu = {}
local green_menu = {}

function blue_menu:on_draw(dst_surface)
  dst_surface:fill_color(blue, 0, 0, 32, 16)
end

function green_menu:on_draw(dst_surface)
  dst_surface:fill_color(green, 0, 0, 16, 32)
end

function map:on_opening_transition_finished()

  -- Need to wait for the fade in transition to finish
  -- since it changes the colors.
  sol.menu.start(map, blue_menu)
  sol.menu.start(map, green_menu)

  sol.timer.start(map, 50, function()
    expected_color = green
  end)

  sol.timer.start(map, 500, function()
    sol.menu.bring_to_front(blue_menu)
    expected_color = blue
  end)

  sol.timer.start(map, 1000, function()
    sol.menu.bring_to_front(green_menu)
    expected_color = green
  end)

  sol.timer.start(map, 1500, function()
    sol.menu.bring_to_front(green_menu)
    expected_color = green
  end)

  sol.timer.start(map, 2000, function()
    sol.menu.bring_to_back(blue_menu)
    expected_color = green
  end)

  sol.timer.start(map, 2500, function()
    sol.menu.bring_to_back(green_menu)
    expected_color = blue
  end)

  sol.timer.start(map, 3000, sol.main.exit)
end

function game:on_draw(dst_surface)

  if expected_color == nil then
    return
  end
  local pixels = dst_surface:get_pixels()
  assert_equal_color({ pixels:byte(1, 3) }, expected_color)
end
