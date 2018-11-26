#include <solarus/graphics/glrenderer/GlRenderer.h>
#include <solarus/graphics/glrenderer/GlTexture.h>
#include <solarus/graphics/glrenderer/GlShader.h>
#include <solarus/graphics/Video.h>
#include <solarus/graphics/Surface.h>
#include <solarus/core/Debug.h>
#include <solarus/graphics/Shader.h>

namespace Solarus {

GlRenderer* GlRenderer::instance = nullptr;
GlRenderer::GlFunctions GlRenderer::ctx;

GlRenderer::GlRenderer(SDL_GLContext ctx) :
  sdl_gl_context(ctx),
  screen_fbo{0,glm::mat4()}
{

  Debug::check_assertion(!instance,"Creating two GL renderer");
  instance = this; //Set this renderer as the unique instance
}

RendererPtr GlRenderer::create(SDL_Window* window) {
  //Try to create context (core or es context)
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,SDL_GL_CONTEXT_PROFILE_CORE | SDL_GL_CONTEXT_PROFILE_ES);
  SDL_GLContext sdl_ctx = SDL_GL_CreateContext(window);
  if(!sdl_ctx) {
    return nullptr;
  }
  //Contex created, populate ctx
  #if SDL_VIDEO_DRIVER_UIKIT || SDL_VIDEO_DRIVER_PANDORA
  #define SDL_PROC(ret,func,params) ctx.func=func;
  #else
  #define SDL_PROC(ret,func,params) \
    do { \
    ctx.func = reinterpret_cast<APIENTRY ret(*)params>(SDL_GL_GetProcAddress(#func)); \
    if ( ! ctx.func ) { \
    Debug::warning(std::string("Couldn't load GLES2 function" #func)+  SDL_GetError()); \
    return nullptr; \
  } \
  } while ( 0 );
  #endif
  #include "solarus/graphics/glrenderer/gles2funcs.h"
  #undef SDL_PROC

  //Context populated create Renderer
  return RendererPtr(new GlRenderer(sdl_ctx));
}

SurfaceImplPtr GlRenderer::create_texture(int width, int height) {
  auto simpl = new GlTexture(width,height);
  clear(*simpl);
  return SurfaceImplPtr(simpl);
}

SurfaceImplPtr GlRenderer::create_texture(SDL_Surface_UniquePtr&& surface) {
  return SurfaceImplPtr(new GlTexture(std::move(surface)));
}

SurfaceImplPtr GlRenderer::create_window_surface(SDL_Window* /*w*/, int width, int height) {
  return SurfaceImplPtr(new GlTexture(width,height,true));
}

ShaderPtr GlRenderer::create_shader(const std::string& shader_id) {
  return std::make_shared<GlShader>(shader_id);
}

ShaderPtr GlRenderer::create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) {
  return std::make_shared<GlShader>(vertex_source, fragment_source, scaling_factor);
}

void GlRenderer::set_render_target(SurfaceImpl& texture) {
  set_render_target(texture.as<GlTexture>());
}

void GlRenderer::set_render_target(GlTexture* target) {
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
  return std::string("GlRenderer"); //TODO
}

void GlRenderer::render(SDL_Window* /*window*/, const SurfacePtr &quest_surface, const ShaderPtr &shader) {

}

void GlRenderer::present(SDL_Window* window) {
  SDL_GL_SwapWindow(window);
}

void GlRenderer::on_window_size_changed(const Rectangle& viewport) {
  //TODO
}

/**
 * @brief compute sdl blendmode to use when writing a surface onto another
 * @param dst_surface written to surface
 * @param src_surface read from surface
 * @param blend_mode  solarus blend mode
 * @return a sdl blendmode taking premultiply into account
 */
//SDL_BlendMode GlRenderer::make_sdl_blend_mode(const SurfaceImpl& dst_surface, const SurfaceImpl& src_surface, BlendMode blend_mode) {

const DrawProxy& GlRenderer::default_terminal() const {
  return *static_cast<const DrawProxy*>(main_shader);
}

GlRenderer::~GlRenderer() {
  SDL_GL_DeleteContext(sdl_gl_context);
}

GlRenderer::Fbo* GlRenderer::get_fbo(int width, int height, bool screen) {
  if(screen) return &screen_fbo;
  size_t key =  (static_cast<size_t>(width) << 32) & height;
  auto it = fbos.find(key);
  if(it != fbos.end()) {
    return &it->second;
  }
  GLuint fbo;
  ctx.glGenFramebuffers(1,&fbo);
  glm::mat4 view = glm::ortho<float>(0,width,0,height);
  return &fbos.insert({key,{fbo,view}}).first->second;
}

}
