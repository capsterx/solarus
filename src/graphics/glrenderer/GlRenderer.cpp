#include <solarus/graphics/glrenderer/GlRenderer.h>
#include <solarus/graphics/glrenderer/GlSurfaceImpl.h>
#include <solarus/graphics/glrenderer/GlShader.h>
#include <solarus/graphics/Video.h>
#include <solarus/graphics/Surface.h>
#include <solarus/core/Debug.h>
#include <solarus/graphics/Shader.h>

#include <SDL_render.h>
#include <SDL_hints.h>

namespace Solarus {

GlRenderer* GlRenderer::instance = nullptr;

GlRenderer::GlRenderer(SDL_Renderer* a_renderer) : renderer(a_renderer) {
  if(!renderer) {
    auto rgba_format = Video::get_pixel_format();
    software_screen.reset(SDL_CreateRGBSurface(
        0,
        320,
        240,
        32,
        rgba_format->Rmask,
        rgba_format->Gmask,
        rgba_format->Bmask,
        rgba_format->Amask
    ));
    renderer = SDL_CreateSoftwareRenderer(software_screen.get());

  }
  Debug::check_assertion(!instance,"Creating two SDL renderer");
  instance = this; //Set this renderer as the unique instance
}

RendererPtr GlRenderer::create(SDL_Window* window) {
  if(!window) {
    //No window... asked for a software renderer
    return RendererPtr(new GlRenderer(nullptr));
  }

  // Set OpenGL as the default renderer driver when available, to avoid using Direct3d.
  SDL_SetHintWithPriority(SDL_HINT_RENDER_DRIVER, "opengl", SDL_HINT_DEFAULT);

  // Set the default OpenGL built-in shader (nearest).
  SDL_SetHint(SDL_HINT_RENDER_OPENGL_SHADERS, "1");

  auto renderer = SDL_CreateRenderer(
        window,
        -1,
        SDL_RENDERER_ACCELERATED);
  if(not renderer) {
    renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_SOFTWARE);
  }
  if(not renderer) {
    return nullptr;
  } else {
    //Init shaders :
    if(!GlShader::initialize()) {
      //return nullptr; //TODO Set some flags
    }

    auto size = Video::get_quest_size();
    SDL_RenderSetLogicalSize(renderer,size.width,size.height);

    return RendererPtr(new GlRenderer(renderer));
  }
}

SurfaceImplPtr GlRenderer::create_texture(int width, int height) {
  auto simpl = new GlSurfaceImpl(renderer,width,height);
  clear(*simpl);
  return SurfaceImplPtr(simpl);
}

SurfaceImplPtr GlRenderer::create_texture(SDL_Surface_UniquePtr&& surface) {
  return SurfaceImplPtr(new GlSurfaceImpl(renderer,std::move(surface)));
}

SurfaceImplPtr GlRenderer::create_window_surface(SDL_Window* /*w*/, int width, int height) {
  return SurfaceImplPtr(new GlSurfaceImpl(renderer,width,height,true));
}

ShaderPtr GlRenderer::create_shader(const std::string& shader_id) {
  return std::make_shared<GlShader>(shader_id);
}

ShaderPtr GlRenderer::create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) {
  return std::make_shared<GlShader>(vertex_source, fragment_source, scaling_factor);
}

void GlRenderer::set_render_target(SurfaceImpl& texture) {
  set_render_target(texture.as<GlSurfaceImpl>().targetable().get_texture());
}

void GlRenderer::set_render_target(SDL_Texture* target) {
  if(target != render_target || !valid_target) {
    SDL_SetRenderTarget(renderer,target);
    render_target=target;
    valid_target = true;
  }
}

void GlRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) {

}

void GlRenderer::clear(SurfaceImpl& dst) {

}

void GlRenderer::fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode) {

}

void GlRenderer::invalidate(const SurfaceImpl& surf) {

}

std::string GlRenderer::get_name() const {
  SDL_RendererInfo renderer_info;
  SDL_GetRendererInfo(renderer, &renderer_info);
  return std::string("SDLRenderer : ") + renderer_info.name;
}

void GlRenderer::render(SDL_Window* /*window*/, const SurfacePtr &quest_surface, const ShaderPtr &shader) {

}

void GlRenderer::present(SDL_Window* /*window*/) {
  SDL_RenderPresent(renderer);
}

void GlRenderer::on_window_size_changed(const Rectangle& viewport) {
  SDL_RenderSetViewport(renderer,viewport);
}

/**
 * @brief compute sdl blendmode to use when writing a surface onto another
 * @param dst_surface written to surface
 * @param src_surface read from surface
 * @param blend_mode  solarus blend mode
 * @return a sdl blendmode taking premultiply into account
 */
//SDL_BlendMode GlRenderer::make_sdl_blend_mode(const SurfaceImpl& dst_surface, const SurfaceImpl& src_surface, BlendMode blend_mode) {

GlRenderer::~GlRenderer() {
  SDL_DestroyRenderer(renderer);
}

}
