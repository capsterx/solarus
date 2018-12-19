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
       sol.video.set_mode("normal")  
    local shader = sol.shader.create({
      vertex_source = vertex_source,
      fragment_source = fragment_source,
    })
    assert(shader ~= nil)
    assert(shader:get_vertex_source() == vertex_source)
    assert(shader:get_fragment_source() == fragment_source)
    sol.video.set_shader(shader) -- set hardware filter from source

    function sol.video:on_draw(screen_hw) -- get hardware filter result and compare
      sol.main.exit()
    end
  end
end
