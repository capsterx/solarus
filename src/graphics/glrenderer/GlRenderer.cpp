#include <solarus/graphics/glrenderer/GlRenderer.h>
#include <solarus/graphics/glrenderer/GlTexture.h>
#include <solarus/graphics/glrenderer/GlShader.h>
#include <solarus/graphics/Video.h>
#include <solarus/graphics/Surface.h>
#include <solarus/core/Debug.h>
#include <solarus/core/Logger.h>
#include <solarus/graphics/Shader.h>
#include <solarus/graphics/DefaultShaders.h>
#include <solarus/core/System.h>

#include <glm/gtx/matrix_transform_2d.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <array>
#include <sstream>

namespace Solarus {

using namespace glm;

GlRenderer* GlRenderer::instance = nullptr;
GlRenderer::GlFunctions GlRenderer::ctx;

GlRenderer::GlRenderer(SDL_GLContext ctx) :
  sdl_gl_context(ctx),
  screen_fbo{0,glm::mat4()}
{

  Debug::check_assertion(!instance,"Creating two GL renderer");
  instance = this; //Set this renderer as the unique instance


  create_vbo(256); //TODO check sprite buffer size

  //Create main shader
  main_shader = create_shader(DefaultShaders::get_default_vertex_source(),
                              DefaultShaders::get_default_fragment_source(),
                              0.0);

  Debug::check_assertion(static_cast<bool>(main_shader),"Failed to compile glRenderer main shader");
}

/**
 * \brief Check for a possible error returned by glGetError().
 */
void GlRenderer::check_gl_error() {
  GLenum gl_error(glGetError());

  while (gl_error != GL_NO_ERROR) {
    std::string error;

    switch(gl_error) {
    case GL_INVALID_OPERATION:
      error="INVALID_OPERATION";
      break;
    case GL_INVALID_ENUM:
      error="INVALID_ENUM";
      break;
    case GL_INVALID_VALUE:
      error="INVALID_VALUE";
      break;
    case GL_OUT_OF_MEMORY:
      error="OUT_OF_MEMORY";
      break;
    case GL_INVALID_FRAMEBUFFER_OPERATION:
      error="INVALID_FRAMEBUFFER_OPERATION";
      break;
    }

    Debug::error(std::string("GL_") + error.c_str() + std::string(" - "));
    gl_error = ctx.glGetError();
  }
}

RendererPtr GlRenderer::create(SDL_Window* window) {
  //Try to create context (core or es context)
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,SDL_GL_CONTEXT_PROFILE_CORE);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
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

  GLint flags;
  ctx.glGetIntegerv(GL_CONTEXT_FLAGS, &flags);
  if(flags & GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT) {
    Logger::info("OpenGL core profile");
  }

  GL_CHECK(ctx.glClearColor(0.f,0.f,0.f,0.f));
  GL_CHECK(ctx.glEnable(GL_BLEND));
  GL_CHECK(ctx.glDisable(GL_CULL_FACE));
  //Set blending to BLEND
  GL_CHECK(ctx.glBlendEquationSeparate(GL_FUNC_ADD,GL_FUNC_ADD));
  //glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
  //GL_CHECK(ctx.glActiveTexture(GL_TEXTURE0));

  Debug::check_assertion(GlShader::initialize(),"shader failed to initialize after gl");

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
  if(target != current_target) {
    auto* fbo = target->targetable().fbo;
    GL_CHECK(ctx.glBindFramebuffer(GL_FRAMEBUFFER,fbo->id));
    if(fbo->id) { //Render to Texture
      GL_CHECK(ctx.glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,target->get_texture(),0));
      GL_CHECK(ctx.glViewport(0,0,
                     target->get_width(),
                     target->get_height()));
      Debug::check_assertion(ctx.glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE,"glFrameBufferTexture2D failed");
    } else { //Render to screen
      GL_CHECK(ctx.glViewport(window_viewport.get_left(),
                     window_viewport.get_top(),
                     window_viewport.get_width(),
                     window_viewport.get_height()));
    }
    current_target = target;
  }
}

void GlRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) {
  draw(dst,src,infos,main_shader.get()->as<GlShader>());
}

void GlRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos, GlShader& shader) {
  set_state(&src.as<GlTexture>(),&shader,&dst.as<GlTexture>(),infos.blend_mode);
  GL_CHECK(ctx.glUniform1i(shader.get_uniform_location(VCOLOR_ONLY_NAME),false));
  add_sprite(infos);
}

void GlRenderer::clear(SurfaceImpl& dst) {
  restart_batch();
  set_render_target(dst);
  ctx.glClear(GL_COLOR_BUFFER_BIT);
}

void GlRenderer::fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode) {
  GlShader& ms = main_shader->as<GlShader>();
  set_state(nullptr,&ms,&dst.as<GlTexture>(),mode);
  GL_CHECK(ctx.glUniform1i(ms.get_uniform_location(VCOLOR_ONLY_NAME),true)); //Set color only as uniform
  add_sprite(DrawInfos(
               where,
               where.get_top_left(),
               Point(),
               mode,
               255,
               0.0,
               Scale(),
               color,
               null_proxy
               ));
}

void GlRenderer::invalidate(const SurfaceImpl& surf) {
  const GlTexture* tex = &surf.as<GlTexture>();
  //TODO
  if(tex == current_target) {
    current_target = nullptr;
  }

  if(tex == current_texture) {
    current_texture = nullptr;
  }
}

std::string GlRenderer::get_name() const {
  return std::string("GlRenderer"); //TODO
}

void GlRenderer::present(SDL_Window* window) {
  restart_batch(); //Draw last batch that could be 'stuck'
  SDL_GL_SwapWindow(window);
}

void GlRenderer::on_window_size_changed(const Rectangle& viewport) {
  //TODO
  if(!viewport.is_flat()) {
    window_viewport = viewport;
    screen_fbo.view = glm::ortho<float>(0,viewport.get_width(),viewport.get_height(),0);
  } else {
    Debug::warning("Ignoring zero area window size");
  }
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
  return static_cast<const DrawProxy&>(*main_shader.get());
}

GlRenderer::~GlRenderer() {
  ctx.glDeleteVertexArrays(1,&vao); //TODO delete rest
  SDL_GL_DeleteContext(sdl_gl_context);
}

GlRenderer::Fbo* GlRenderer::get_fbo(int width, int height, bool screen) {
  if(screen) return &screen_fbo;
  size_t key =  (static_cast<size_t>(width) << 32) | static_cast<size_t>(height);
  int rw = key >> 32;
  int rh = key & 0xFFFFFFFF;
  Debug::check_assertion(rw == width,"recovered width does not match");
  Debug::check_assertion(rh == height,"recovered height does not match");
  auto it = fbos.find(key);
  if(it != fbos.end()) {
    return &it->second;
  }
  GLuint fbo;
  GL_CHECK(ctx.glGenFramebuffers(1,&fbo));
  glm::mat4 view = glm::ortho<float>(0,width,0,height);
  return &fbos.insert({key,{fbo,view}}).first->second;
}

bool GlRenderer::use_bmap() const {
#ifdef ANDROID
  return false;
#else
  return false; //TODO check this
#endif
}

size_t GlRenderer::buffered_indices() const {
  return buffered_sprites*6;
}

size_t GlRenderer::buffered_vertices() const {
  return buffered_sprites*4;
}

void GlRenderer::restart_batch() {
  if(current_target && buffered_sprites > 0) {
    //Stuff to render!
    if(test_texture != current_target) {
      Debug::warning("InCONSISTENT state");
    }

    GL_CHECK(ctx.glBufferSubData(GL_ARRAY_BUFFER,0,buffered_vertices()*sizeof(Vertex),vertex_buffer.data()));
    GL_CHECK(ctx.glDrawElements(GL_TRIANGLES,buffered_indices(),GL_UNSIGNED_INT,nullptr));
    /*if(buffered_sprites > 2) {
      std::ostringstream oss;
      oss << "rendererd " << buffered_sprites;
      Logger::info(oss.str());
    }*/
  }
  test_texture = nullptr;
  //Done rendering, start actual batch
  current_vertex = vertex_buffer.data();
  buffered_sprites = 0; //Reset sprite count, lets accumulate sprites!
}

void GlRenderer::set_shader(GlShader* shader) {
  if(shader != current_shader) {
    shader->bind();
    if(current_shader){
      current_shader->unbind();
    }
    current_shader = shader;
  }
}

void GlRenderer::set_texture(const GlTexture *texture) {
  if(texture != current_texture) {
    //Change texture binding state
    current_texture = texture;
    rebind_texture();
  }
}

void GlRenderer::rebind_texture() {
  if(current_texture) { //Texture might be null if we want no texture for filling
    GL_CHECK(ctx.glActiveTexture(GL_TEXTURE0));
    GL_CHECK(ctx.glBindTexture(GL_TEXTURE_2D,current_texture->get_texture()));
  }
}

void GlRenderer::set_state(const GlTexture *src, GlShader* shad, GlTexture* dst, BlendMode mode) {

  GLBlendMode wanted_mode = make_gl_blend_modes(*dst,src,mode);
  if(src != current_texture ||
     shad != current_shader ||
     dst != current_target ||
     wanted_mode != current_blend_mode) { //Need to restart the batch!
    //bool should_recompute_mvp = dst_src_shad;
    restart_batch(); //Draw current buffer if needed
    set_shader(shad);
    set_render_target(dst);
    set_texture(src);
    set_blend_mode(wanted_mode);

    //Resend mvp and uvm
    GL_CHECK(ctx.glUniformMatrix4fv(current_shader->get_uniform_location(Shader::MVP_MATRIX_NAME),
                           1,
                           GL_FALSE,
                           glm::value_ptr(dst->fbo->view)));
    if(current_texture) {
      GL_CHECK(ctx.glUniformMatrix3fv(current_shader->get_uniform_location(Shader::UV_MATRIX_NAME),
                             1,
                             GL_FALSE,
                             glm::value_ptr(current_texture->uv_transform)));
      int sw = current_texture->get_width();
      int sh = current_texture->get_height();
      ctx.glUniform2f(
            current_shader->get_uniform_location(Shader::INPUT_SIZE_NAME),
            sw,sh);
    }

    if(current_target) {
      int dw = current_target->get_width();
      int dh = current_target->get_height();
      ctx.glUniform2f(
            current_shader->get_uniform_location(Shader::OUTPUT_SIZE_NAME),
            dw,dh);
    }
    ctx.glUniform1i(
          current_shader->get_uniform_location(Shader::TIME_NAME),
          System::now());
  }
}

void GlRenderer::set_blend_mode(GLBlendMode mode) {
  if(mode != current_blend_mode) {
    current_blend_mode = mode;
    GLenum srcRGB,dstRGB,srcA,dstA;
    std::tie(srcRGB,dstRGB,srcA,dstA) = mode;
    GL_CHECK(ctx.glBlendFuncSeparate(srcRGB,dstRGB,
                            srcA,dstA));
  }
}

GlRenderer::GLBlendMode GlRenderer::make_gl_blend_modes(const GlTexture& dst, const GlTexture* src, BlendMode mode) {
  if(dst.is_premultiplied() && mode == BlendMode::BLEND) { //TODO refactor this a bit
    return {GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE_MINUS_SRC_ALPHA};
  } else if(src && src->is_premultiplied() && mode == BlendMode::BLEND) {
    return {GL_ONE,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE_MINUS_SRC_ALPHA};
  } else {
    return make_gl_blend_modes(mode);
  }
}

GlRenderer::GLBlendMode GlRenderer::make_gl_blend_modes(BlendMode mode) {
  auto sym = [](GLenum src,GLenum dst) -> GLBlendMode {
    return {src,dst,src,dst};
  };
  switch(mode) {
  case BlendMode::BLEND:
    return sym(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
  case BlendMode::MULTIPLY:
    return {GL_ZERO,GL_SRC_COLOR,GL_ZERO,GL_SRC_ALPHA};
  case BlendMode::ADD:
    return sym(GL_ONE,GL_ONE);
  case BlendMode::NONE:
    return sym(GL_ONE,GL_ZERO);
  }
  return sym(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
}

void GlRenderer::create_vbo(size_t num_sprites) {
  buffer_size = num_sprites;

  GL_CHECK(ctx.glGenVertexArrays(1,&vao)); //TODO for android ifndef this
  GL_CHECK(ctx.glGenBuffers(1,&vbo));
  GL_CHECK(ctx.glGenBuffers(1,&ibo));

  size_t indice_count = num_sprites*6;
  size_t vertex_count = num_sprites*4;

  GL_CHECK(ctx.glBindVertexArray(vao));

  GL_CHECK(ctx.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ibo));
  std::vector<GLuint> indices(indice_count);
  static constexpr std::array<GLuint,6> quad{{0,1,2,2,3,0}};
  for(size_t i = 0; i < num_sprites; i++) {
    size_t vbase = i*4;
    size_t ibase = i*6;
    for(size_t j = 0; j < quad.size(); j++) {
      indices[ibase+j] = vbase + quad[j];
    }
  }
  GL_CHECK(ctx.glBufferData(GL_ELEMENT_ARRAY_BUFFER,indice_count*sizeof(GLuint),indices.data(),GL_STATIC_DRAW));

  GL_CHECK(ctx.glBindBuffer(GL_ARRAY_BUFFER,vbo));

  vertex_buffer.resize(vertex_count);
  GL_CHECK(ctx.glBufferData(GL_ARRAY_BUFFER,vertex_buffer.size()*sizeof(Vertex),nullptr,GL_STREAM_DRAW));
}

void GlRenderer::shader_about_to_change(GlShader* shader) {
  if(shader == current_shader) {
    restart_batch(); //Draw the sprites before shader state changes
  }
}

void GlRenderer::add_sprite(const DrawInfos& infos) {
  if(buffered_sprites >= buffer_size) {
    restart_batch();
  }

  if(!test_texture)
    test_texture = current_target;

  vec2 trans = infos.transformation_origin;
  vec2 pos = infos.dst_position + infos.transformation_origin;
  vec2 scale = infos.scale;
  vec2 size = infos.region.get_size();
  vec2 ototl = -trans;
  vec2 otobr = size-trans;
  vec2 tl = (ototl)*scale;
  vec2 bl = vec2(ototl.x,otobr.y) * scale;
  vec2 br = (otobr) * scale;
  vec2 tr = vec2(otobr.x,ototl.y) * scale;
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
    current_vertex[i].color = infos.color;
    current_vertex[i].color.a = (infos.color.a * infos.opacity) / 255; //modulate vcolor opacity with desired opacity
  }

  current_vertex += 4; //Shift current quad index
  buffered_sprites++;
}

}
