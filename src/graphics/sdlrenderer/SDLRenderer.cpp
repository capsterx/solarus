#include <solarus/graphics/sdlrenderer/SDLRenderer.h>
#include <solarus/graphics/sdlrenderer/SDLSurfaceImpl.h>
#include <solarus/graphics/sdlrenderer/SDLShader.h>
#include <solarus/graphics/Video.h>
#include <solarus/graphics/Surface.h>
#include <solarus/core/Debug.h>
#include <solarus/graphics/Shader.h>

#include <SDL_render.h>
#include <SDL_hints.h>

namespace Solarus {

SDLRenderer* SDLRenderer::instance = nullptr;

void SDLRenderer::SurfaceDraw::draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& params) const {
  SDLRenderer::get().draw(dst_surface.get_impl(),src_surface.get_impl(),params);
}

SDLRenderer::SDLRenderer(SDL_Renderer* a_renderer, bool shaders) : renderer(a_renderer),
  shaders(shaders) {
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

RendererPtr SDLRenderer::create(SDL_Window* window, bool force_software) {
  if(!window) {
    //No window... asked for a software renderer
    return RendererPtr(new SDLRenderer(nullptr,false));
  }

  // Set OpenGL as the default renderer driver when available, to avoid using Direct3d.
  SDL_SetHintWithPriority(SDL_HINT_RENDER_DRIVER, "opengl", SDL_HINT_DEFAULT);

  if(force_software) {
    SDL_SetHintWithPriority(SDL_HINT_RENDER_DRIVER, "software", SDL_HINT_OVERRIDE);
  }

  // Set the default OpenGL built-in shader (nearest).
  SDL_SetHint(SDL_HINT_RENDER_OPENGL_SHADERS, "1");

  SDL_Renderer* renderer = force_software ?
        nullptr :
        SDL_CreateRenderer(
          window,
          -1,
          SDL_RENDERER_ACCELERATED);
  if(not renderer) {
    renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_SOFTWARE);
  }
  if(not renderer) {
    return nullptr;
  } else {
    //Init shaders
    bool shaders = not force_software and SDLShader::initialize();

    auto size = Video::get_quest_size();
    SDL_RenderSetLogicalSize(renderer,size.width,size.height);

    return RendererPtr(new SDLRenderer(renderer, shaders));
  }
}

SurfaceImplPtr SDLRenderer::create_texture(int width, int height) {
  auto simpl = new SDLSurfaceImpl(renderer,width,height);
  clear(*simpl);
  return SurfaceImplPtr(simpl);
}

SurfaceImplPtr SDLRenderer::create_texture(SDL_Surface_UniquePtr&& surface) {
  return SurfaceImplPtr(new SDLSurfaceImpl(renderer, std::move(surface)));
}

SurfaceImplPtr SDLRenderer::create_window_surface(SDL_Window* /*w*/, int width, int height) {
  return SurfaceImplPtr(new SDLSurfaceImpl(renderer, width, height, true));
}

ShaderPtr SDLRenderer::create_shader(const std::string& shader_id) {
  return std::make_shared<SDLShader>(shader_id);
}

ShaderPtr SDLRenderer::create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) {
  return std::make_shared<SDLShader>(
                     vertex_source,
                     fragment_source,
                     scaling_factor);
}

void SDLRenderer::set_render_target(SDL_Texture* target) {
  if(target != render_target || !valid_target) {
    SDL_SetRenderTarget(renderer, target);
    render_target=target;
    valid_target = true;
  }
}

void SDLRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) {
  SDLSurfaceImpl& sdst = dst.as<SDLSurfaceImpl>().targetable();
  const SDLSurfaceImpl& ssrc = src.as<SDLSurfaceImpl>();

  set_render_target(sdst.get_texture());
  Rectangle dst_rect = infos.dst_rectangle();
  if(!ssrc.get_texture()) {
    Debug::error("Could not draw screen on another surface");
  }

  SDL_BlendMode mode = make_sdl_blend_mode(dst,src,infos.blend_mode);
  SOLARUS_CHECK_SDL_HIGHER(SDL_SetTextureBlendMode(ssrc.get_texture(),mode),-1);
  SOLARUS_CHECK_SDL(SDL_SetTextureAlphaMod(ssrc.get_texture(),infos.opacity));
  if(infos.should_use_ex()) {
    SDL_Point origin= infos.sdl_origin();
    SOLARUS_CHECK_SDL(SDL_RenderCopyEx(renderer,ssrc.get_texture(),infos.region,dst_rect,infos.rotation,&origin,infos.flips()));
  } else {
    SOLARUS_CHECK_SDL(SDL_RenderCopy(renderer,ssrc.get_texture(),infos.region,dst_rect));
  }
  sdst.surface_dirty = true;
}

void SDLRenderer::clear(SurfaceImpl& dst) {
  SDLSurfaceImpl& sdst = dst.as<SDLSurfaceImpl>().targetable();
  set_render_target(sdst.get_texture());

  SOLARUS_CHECK_SDL(SDL_SetRenderDrawColor(renderer,0,0,0,0));
  if(sdst.get_texture()) { //texture can be nullptr in case of the screen
    SOLARUS_CHECK_SDL(SDL_SetTextureBlendMode(sdst.get_texture(),SDL_BLENDMODE_BLEND));
  }
  SOLARUS_CHECK_SDL(SDL_RenderClear(renderer));

  sdst.surface_dirty = true;
}

void SDLRenderer::fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode) {
  SDLSurfaceImpl& sdst = dst.as<SDLSurfaceImpl>().targetable();
  set_render_target(sdst.get_texture());

  Uint8 r,g,b,a;
  color.get_components(r,g,b,a);
  SOLARUS_CHECK_SDL(SDL_SetRenderDrawColor(renderer,r,g,b,a));
  SOLARUS_CHECK_SDL(SDL_SetRenderDrawBlendMode(renderer,make_sdl_blend_mode(mode)));
  SOLARUS_CHECK_SDL(SDL_RenderFillRect(renderer,where));

  sdst.surface_dirty = true;
}

void SDLRenderer::invalidate(const SurfaceImpl& surf) {
  const auto& ssurf = surf.as<SDLSurfaceImpl>();

  if(render_target == ssurf.get_texture()) {
    valid_target = false;
  }
}

void SDLRenderer::bind_as_gl_target(SurfaceImpl &surf) {
  SDL_GL_BindTexture(surf.as<SDLSurfaceImpl>().get_texture(),nullptr,nullptr);
}

void SDLRenderer::bind_as_gl_texture(const SurfaceImpl& surf) {
  set_render_target(surf.as<SDLSurfaceImpl>().get_texture());
}

std::string SDLRenderer::get_name() const {
  SDL_RendererInfo renderer_info;
  SDL_GetRendererInfo(renderer, &renderer_info);
  return std::string("SDLRenderer : ") + renderer_info.name;
}

void SDLRenderer::present(SDL_Window* /*window*/) {
  SDL_RenderPresent(renderer);
}

void SDLRenderer::on_window_size_changed(const Rectangle& viewport) {
  SDL_RenderSetViewport(renderer,viewport);
}

/**
 * @brief compute sdl blendmode to use when writing a surface onto another
 * @param dst_surface written to surface
 * @param src_surface read from surface
 * @param blend_mode  solarus blend mode
 * @return a sdl blendmode taking premultiply into account
 */
SDL_BlendMode SDLRenderer::make_sdl_blend_mode(const SurfaceImpl& dst_surface, const SurfaceImpl& src_surface, BlendMode blend_mode) {
  if(dst_surface.is_premultiplied()) { //TODO refactor this a bit
    switch(blend_mode) {
      case BlendMode::NONE:
        return SDL_BLENDMODE_NONE;
      case BlendMode::MULTIPLY:
        return SDL_BLENDMODE_MOD;
      case BlendMode::ADD:
        return SDL_BLENDMODE_ADD;
      case BlendMode::BLEND:
        return SDL_ComposeCustomBlendMode(
              SDL_BLENDFACTOR_SRC_ALPHA,
              SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
              SDL_BLENDOPERATION_ADD,
              SDL_BLENDFACTOR_ONE,
              SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
              SDL_BLENDOPERATION_ADD);
    }
  } else {
    //Straight destination
    if(src_surface.is_premultiplied() && blend_mode == BlendMode::BLEND)
      return SDL_ComposeCustomBlendMode(
            SDL_BLENDFACTOR_ONE,
            SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
            SDL_BLENDOPERATION_ADD,
            SDL_BLENDFACTOR_ONE,
            SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
            SDL_BLENDOPERATION_ADD);
    switch(blend_mode) { //TODO check other modes
      case BlendMode::NONE:
        return SDL_BLENDMODE_NONE;
      case BlendMode::MULTIPLY:
        return SDL_BLENDMODE_MOD;
      case BlendMode::ADD:
        return SDL_BLENDMODE_ADD;
      case BlendMode::BLEND:
        return SDL_BLENDMODE_BLEND;
    }
  }
  return SDL_BLENDMODE_BLEND;
}

SDL_BlendMode SDLRenderer::make_sdl_blend_mode(BlendMode blend_mode) {
  switch (blend_mode) {
  case BlendMode::ADD:
    return SDL_BLENDMODE_ADD;
  case BlendMode::MULTIPLY:
    return SDL_BLENDMODE_MOD;
  case BlendMode::BLEND:
    return SDL_BLENDMODE_BLEND;
  case BlendMode::NONE:
    return SDL_BLENDMODE_NONE;
  }
  return SDL_BLENDMODE_BLEND;
}

SDLRenderer::~SDLRenderer() {
  SDL_DestroyRenderer(renderer);
}

}
