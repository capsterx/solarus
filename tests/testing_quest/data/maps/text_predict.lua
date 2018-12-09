-- Lua script of map text_predict.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
  local font_ids = {
    'enter_command',
    '8_bit'
  }
  
  local font_sizes = {
    10,
    15,
    20,
  }
  
  local texts = {
    "Some text",
    "examples that",
    "expose",
    "various lenght",
    "et même",
    "en français",
    "utf8",
    "this should be enough"
  }
  for _,font_id in ipairs(font_ids) do
    for _, font_size in ipairs(font_sizes) do
      for _,text in ipairs(texts) do
        local pw,ph = sol.text_surface.get_predicted_size(font_id,font_size,text)
        local aw,ah = sol.text_surface.create({
          font = font_id,
          font_size = font_size,
          text = text
        }):get_size()
        assert_equal(aw,pw,"predicted text width should match actual width")
        assert_equal(ah,ph,"predicted text height should match actual height")
      end
    end
  end
  sol.main.exit()
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
