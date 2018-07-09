local map = ...
local game = map:get_game()

local vertex_file = sol.file.open("shaders/scale2x.vert.glsl")
local vertex_source = vertex_file:read("*a")
local fragment_file = sol.file.open("shaders/scale2x.frag.glsl")
local fragment_source = fragment_file:read("*a")

assert(vertex_source ~= nil and #vertex_source > 0)
assert(fragment_source ~= nil and #fragment_source > 0)

function map:on_opening_transition_finished()

  sol.video.set_mode("scale2x") -- set software filter
  function sol.video:on_draw(screen_sw) -- get software filter result
    local sw_pix = screen_sw:get_pixels()
    assert(sw_pix ~= nil)
    assert(#sw_pix > 0)

    sol.video.set_mode("normal")  
    local shader = sol.shader.create({
      vertex_source = vertex_source,
      fragment_source = fragment_source,
    })
    sol.video.set_shader(shader) -- set hardware filter from source

    function sol.video:on_draw(screen_hw) -- get hardware filter result and compare
      local hw_pix = screen_hw:get_pixels()
      assert(hw_pix ~= nil)
      assert(#hw_pix > 0)
      assert(sw_pix == hw_pix, "Software and shader scale2x don't lead to same result")
      sol.main.exit()
    end
  end
end
