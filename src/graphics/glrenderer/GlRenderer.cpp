#include <solarus/graphics/glrenderer/GlRenderer.h>
#include <solarus/graphics/glrenderer/GlTexture.h>
#include <solarus/graphics/glrenderer/GlShader.h>
#include <solarus/graphics/Video.h>
#include <solarus/graphics/Surface.h>
#include <solarus/core/Debug.h>
#include <solarus/graphics/Shader.h>

#include <glm/gtx/matrix_transform_2d.hpp>

#include <array>

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

  ctx.glClearColor(0.f,0.f,0.f,0.f);
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
  set_render_target(&texture.as<GlTexture>());
}

void GlRenderer::set_render_target(GlTexture* target) {
  auto* fbo = target->targetable().fbo;
  ctx.glBindFramebuffer(GL_FRAMEBUFFER,fbo->id);
  ctx.glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,target->get_texture(),0);
  Debug::check_assertion(ctx.glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE,"glFrameBufferTexture2D failed");
}

void GlRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) {

}

void GlRenderer::clear(SurfaceImpl& dst) {
  set_render_target(dst);
  glClear(GL_COLOR_BUFFER_BIT);
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
  ctx.glViewport(viewport.get_left(),viewport.get_top(),viewport.get_width(),viewport.get_height());
  screen_fbo.view = glm::ortho(0,viewport.get_width(),0,viewport.get_height());
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
  return *static_cast<const DrawProxy*>(main_shader.get());
}

GlRenderer::~GlRenderer() {
  SDL_GL_DeleteContext(sdl_gl_context);
}

GlRenderer::Fbo* GlRenderer::get_fbo(int width, int height, bool screen) {
  if(screen) return &screen_fbo;
  size_t key =  (static_cast<size_t>(width) << 32) & static_cast<size_t>(height);
  auto it = fbos.find(key);
  if(it != fbos.end()) {
    return &it->second;
  }
  GLuint fbo;
  ctx.glGenFramebuffers(1,&fbo);
  glm::mat4 view = glm::ortho<float>(0,width,0,height);
  return &fbos.insert({key,{fbo,view}}).first->second;
}

void GlRenderer::create_vbo(size_t num_sprites) {
  vbos.resize(3); //TODO check the value here
  ctx.glGenBuffers(vbos.size(),vbos.data());
  ctx.glGenBuffers(1,&ibo);

  size_t indice_count = num_sprites*6;
  size_t vertex_count = num_sprites*4;

  ctx.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ibo);
  std::vector<GLuint> indices(indice_count);
  static constexpr std::array<GLuint,6> quad{{0,1,2,2,3,0}};
  for(size_t i = 0; i < num_sprites; i++) {
    size_t vbase = i*4;
    size_t ibase = i*6;
    for(size_t j = 0; j < quad.size(); j++) {
      indices[ibase+j] = vbase + quad[j];
    }
  }
  ctx.glBufferData(GL_ELEMENT_ARRAY_BUFFER,indice_count*sizeof(GLuint),indices.data(),GL_STATIC_DRAW);

  for(auto vbo : vbos) {
    ctx.glBindBuffer(GL_ARRAY_BUFFER,vbo);
    ctx.glBufferData(GL_ARRAY_BUFFER,vertex_count*sizeof(Vertex),nullptr,GL_STREAM_DRAW);
  }
}

void GlRenderer::render_and_swap() {

}

void GlRenderer::add_sprite(const DrawInfos& infos) {
  vec2 trans = infos.transformation_origin;
  vec2 pos = infos.dst_position + infos.transformation_origin;
  vec2 scale = infos.scale;
  vec2 size = infos.region.get_size();
  vec2 ototl = -trans;
  vec2 otobr = size-trans;
  vec2 tl = (ototl)*scale;
  vec2 bl = (vec2(ototl,otobr.y)-trans) * scale;
  vec2 br = (otobr) * scale;
  vec2 tr = (vec2(otobr.x,ototl.y) - trans) * scale;
  if(infos.should_use_ex()) {
    float alpha = infos.rotation;
    mat2 rot = mat2(cos(alpha),-sin(alpha),sin(alpha),cos(alpha));
    tl = rot * tl;
    bl = rot * bl;
    br = rot * br;
    tr = rot * tr;
  }
  current_vertex[0].position = pos + tl;
  current_vertex[1].position = pos + bl;
  current_vertex[2].position = pos + br;
  current_vertex[3].position = pos + tr;

  current_vertex[0].texcoords = infos.region.get_top_left();
  current_vertex[1].texcoords = infos.region.get_bottom_left();
  current_vertex[2].texcoords = infos.region.get_bottom_right();
  current_vertex[3].texcoords = infos.region.get_top_right();

  for(size_t i = 0; i < 4; ++i) {
    current_vertex[i].color.set_alpha(infos.opacity);
  }

  current_vertex += 4; //Shift current quad index
}

}
