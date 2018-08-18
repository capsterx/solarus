local function format_value(value)

  if type(value) == "string" then
    return "'" .. value .. "'"
  end
  return tostring(value)
end

function assert_equal(actual, expected)

  if actual ~= expected then
    error("equality assertion failed: expected " ..
        format_value(expected) .. ", got " ..
        format_value(actual) .. "")
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

function sol.main:on_started()

  assert_equal(sol.language.get_language(), "en")
  assert_equal(sol.main.get_game(), nil)
end

local game_meta = sol.main.get_metatable("game")
function game_meta:on_started()

  assert(sol.main.get_game() ~= nil)
  assert(sol.main.get_game() == self)
  local hero = self:get_hero()
  hero:set_tunic_sprite_id("main_heroes/eldran")
  self:set_max_life(40)
  self:set_life(self:get_max_life())
end
