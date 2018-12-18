-- Postpone a continuation to let engine simulate a bit.
function later(cont)
  local context = sol.main
  local game = sol.main.get_game()
  if game ~= nil then
    context = game:get_map() or game
  end
  sol.timer.start(context, 100, cont):set_suspended_with_map(false)
end

function format_value(value)
  if type(value) == "string" then
    return "'" .. value .. "'"
  end

  if type(value) == "userdata" then
    return tostring(value):gsub("userdata", sol.main.get_type(value))
  end

  return tostring(value)
end

function assert_equal(actual, expected,msg)

  if actual ~= expected then
    local err = string.format("equality assertion failed: expected %s, got %s",
                              format_value(expected),
                              format_value(actual))
    if msg then
      err = string.format("%s (%s)",msg,err)
    end
    error(err)
  end
end


function assert_equal_approx(actual, expected)

  local tolerance = 0.00001
  if math.abs(actual - expected) > tolerance then
    error("equality assertion failed: expected " ..
        format_value(expected) .. ", got " ..
        format_value(actual) .. "")
  end
end

function assert_equal_color(actual_rgba, expected_rgba)

  assert_equal(actual_rgba[1], expected_rgba[1])
  assert_equal(actual_rgba[2], expected_rgba[2])
  assert_equal(actual_rgba[3], expected_rgba[3])
  local alpha = expected_rgba[4] or 255
  if #actual_rgba > 3 then
    assert_equal(actual_rgba[4], alpha)
  end
end

function assert_equal_xy(actual_entity, expected_entity)

  local actual_x, actual_y, actual_width, actual_height = actual_entity:get_bounding_box()
  local expected_x, expected_y, expected_width, expected_height = expected_entity:get_bounding_box()
  assert_equal(actual_x, expected_x)
  assert_equal(actual_y, expected_y)
  assert_equal(actual_width, expected_width)
  assert_equal(actual_height, expected_height)
end

function sol.main:on_started()

  assert_equal(sol.language.get_language(), "en")
  assert_equal(sol.main.get_game(), nil)
end

local game_meta = sol.main.get_metatable("game")
function game_meta:on_started()

  assert(sol.main.get_game() ~= nil)
  assert(sol.main.get_game() == self)
  local hero = self:get_hero()
  self:set_max_life(40)
  self:set_life(self:get_max_life())
end
