-- Lua script of map graphical/scale2x.
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
end

local draw_load

function sol.video:on_draw(screen)
  if draw_load then
    draw_load(screen)
  end
end

function map:on_opening_transition_finished()
  sol.video.set_mode('scale2x'); --set software filter
  function draw_load(screen_sw) -- get software filter result
    local sw_pix = screen_sw:get_pixels()

    sol.video.set_mode('normal')  
    sol.video.set_shader(sol.shader.create('scale2x')) --set hardware filter 

    draw_load = nil
    function draw_load(screen_hw) -- get hardware filter result and compare
      local hw_pix = screen_hw:get_pixels()
      assert(sw_pix == hw_pix, "Software and shader scale2x don't lead to same result")
      sol.main.exit()
    end
  end
end
