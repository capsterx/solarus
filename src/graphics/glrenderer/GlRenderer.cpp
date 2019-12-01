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


#define SOLARUS_SPRITE_BUFFER_SIZE 64

namespace Solarus {

using namespace glm;

GlRenderer* GlRenderer::instance = nullptr;


/**
 * @brief Function that serve as a callback for opengl debugging
 * @param type
 * @param id
 * @param severity
 * @param message
 */
/*void GLAPIENTRY
MessageCallback( GLenum source,
                 GLenum type,
                 GLuint id,
                 GLenum severity,
                 GLsizei length,
                 const GLchar* message,
                 const void* userParam )
{
  using namespace std;
  cerr << "---------------------opengl-callback-start------------" << endl;
  cerr << "message: "<< message << endl;
  cerr << "type: ";
  switch (type) {
  case GL_DEBUG_TYPE_ERROR:
    cerr << "ERROR";
    break;
  case GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR:
    cerr << "DEPRECATED_BEHAVIOR";
    break;
  case GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR:
    cerr << "UNDEFINED_BEHAVIOR";
    break;
  case GL_DEBUG_TYPE_PORTABILITY:
    cerr << "PORTABILITY";
    break;
  case GL_DEBUG_TYPE_PERFORMANCE:
    cerr << "PERFORMANCE";
    break;
  case GL_DEBUG_TYPE_OTHER:
    cerr << "OTHER";
    break;
  }
  cerr << endl;

  cerr << "id: " << id << endl;
  cerr << "severity: ";
  switch (severity){
  case GL_DEBUG_SEVERITY_LOW:
    cerr << "LOW";
    break;
  case GL_DEBUG_SEVERITY_MEDIUM:
    cerr << "MEDIUM";
    break;
  case GL_DEBUG_SEVERITY_HIGH:
    cerr << "HIGH";
    break;
  case GL_DEBUG_SEVERITY_NOTIFICATION:
    cerr << "NOTIFICATION";
    break;
  }
  cerr << endl;
  cerr << "---------------------opengl-callback-end--------------" << endl;
}*/


GlRenderer::GlRenderer(SDL_GLContext sdl_ctx) :
  sdl_gl_context(sdl_ctx),
  screen_fbo{0,glm::mat4(1.f)}
{

  Debug::check_assertion(!instance,"Creating two GL renderer");
  instance = this; //Set this renderer as the unique instance


  create_vbo(SOLARUS_SPRITE_BUFFER_SIZE); //TODO check sprite buffer size

  std::string version((const char *)glGetString(GL_VERSION));
  is_es_context = version.find("OpenGL ES") != std::string::npos;

  //Create main shader
  main_shader = create_shader(DefaultShaders::get_default_vertex_source(),
                              DefaultShaders::get_default_fragment_source(),
                              0.0);

  Debug::check_assertion(static_cast<bool>(main_shader),"Failed to compile glRenderer main shader");
}

RendererPtr GlRenderer::create(SDL_Window* window, bool force_software) {

  if(force_software) {
    return nullptr; // this renderer does not support software rendering
  }
#ifdef SOLARUS_GL_ES
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,SDL_GL_CONTEXT_PROFILE_ES);
#else
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,SDL_GL_CONTEXT_PROFILE_CORE);
#endif

  //Try to create core context
  SDL_GLContext sdl_ctx = SDL_GL_CreateContext(window);
  if(!sdl_ctx) {

    Logger::info("Failed to obtain core GL. Trying compatibility instead...");
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,0);

    sdl_ctx = SDL_GL_CreateContext(window);
    if(!sdl_ctx) {
      return nullptr;
    }
  }

  SDL_GL_SetSwapInterval(1);
  //Contex created, populate ctx

  if(not Gl::load()) {
    Debug::warning("failed to load gl 2.1");
    SDL_GL_DeleteContext(sdl_ctx);
    return nullptr;
  }

  if(not Gl::has_framebuffer()) {
    Debug::warning("failed to load framebuffer extension");
    SDL_GL_DeleteContext(sdl_ctx);
    return nullptr;
  }

#ifdef DEBUG
  /*glEnable(GL_DEBUG_OUTPUT);
  GLuint unusedIds = 0;
  glDebugMessageCallback(MessageCallback,nullptr);
  glDebugMessageControl(GL_DONT_CARE,
                            GL_DONT_CARE,
                            GL_DONT_CARE,
                            0,
                            &unusedIds,
                            true);*/
#endif

  glClearColor(0.f,0.f,0.f,0.f);
  glEnable(GL_BLEND);
  glDisable(GL_CULL_FACE);

  //Set blending to BLEND
  glBlendEquationSeparate(GL_FUNC_ADD,GL_FUNC_ADD);

  Debug::check_assertion(GlShader::initialize(),"shader failed to initialize after gl");

  //Context populated create Renderer
  std::cerr << SDL_GetError();
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

void GlRenderer::set_render_target(GlTexture* target) {
  if(target != current_target) {
    auto* fbo = target->targetable().fbo;
    glBindFramebuffer(GL_FRAMEBUFFER,fbo->id);
    if(fbo->id) { //Render to Texture
      glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,target->get_texture(),0);
      glViewport(0,0,
                 target->get_width(),
                 target->get_height());
#ifndef SOLARUS_GL_ES
      Debug::check_assertion(glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE,"glFrameBufferTexture2D failed");
#endif
    } else { //Render to screen
      glViewport(window_viewport.get_left(),
                 window_viewport.get_top(),
                 window_viewport.get_width(),
                 window_viewport.get_height());
    }
    current_target = target;
  }
}

void GlRenderer::bind_as_gl_target(SurfaceImpl& surf) {
  set_state(current_texture,current_shader,&surf.as<GlTexture>(),current_blend_mode);
}

void GlRenderer::bind_as_gl_texture(const SurfaceImpl& surf) {
  set_state(&surf.as<GlTexture>(),current_shader,current_target,current_blend_mode);
}

void GlRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) {
  draw(dst,src,infos,main_shader.get()->as<GlShader>());
}

/**
 * @brief private draw with shader specified
 * @param dst destination surfaec
 * @param src source surface
 * @param infos draw parameters
 * @param shader shader to use
 */
void GlRenderer::draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos, GlShader& shader) {
  const GlTexture& glsrc = src.as<GlTexture>();
  GlTexture& gldst = dst.as<GlTexture>();
  set_state(&glsrc,&shader,&gldst,make_gl_blend_modes(gldst,&glsrc,infos.blend_mode));
  glUniform1i(shader.get_uniform_location(VCOLOR_ONLY_NAME),false);
  add_sprite(infos);
}

void GlRenderer::clear(SurfaceImpl& dst) {
  GlTexture* t = &dst.as<GlTexture>();
  if(t == current_target) {
    buffered_sprites = 0; //Trash pending batch, after all we'll clear
    glClear(GL_COLOR_BUFFER_BIT);
    restart_batch();
  } else {
    //Switch to target
    set_state(current_texture,current_shader,t,current_blend_mode);
    glClear(GL_COLOR_BUFFER_BIT);
  }
}

/**
 * @brief read pixel of the given texture to a buffer
 * @param from the texture
 * @param to the buffer
 */
void GlRenderer::read_pixels(GlTexture* from, void* to) {
  //Make sure we draw everything before read
  set_state(current_texture,current_shader,from,current_blend_mode,true);
  glReadPixels(0,0,
               from->get_width(),from->get_height(),
               GL_RGBA,
               GL_UNSIGNED_BYTE,
               to);
}

/**
 * @brief put pixels into the given texture
 * @param to texture to upload pixel to
 * @param data pixel data (RGBA unsigned bytes)
 */
void GlRenderer::put_pixels(GlTexture* to, void* data) {
  if(current_target == to) {
    //Texture is attached, detach
    restart_batch(); //draw everything
    glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,0,0);
    current_target = nullptr; //Set target as invalid
  }
  glBindTexture(GL_TEXTURE_2D,to->get_texture());
  glTexSubImage2D(GL_TEXTURE_2D,
                  0,
                  0,0,
                  to->get_width(),to->get_height(),
                  GL_RGBA,GL_UNSIGNED_BYTE,
                  data);
  GlRenderer::get().rebind_texture();
}

void GlRenderer::fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode) {
  GlShader& ms = main_shader->as<GlShader>();
  set_state(nullptr,&ms,&dst.as<GlTexture>(),make_gl_blend_modes(mode));
  glUniform1i(ms.get_uniform_location(VCOLOR_ONLY_NAME),true); //Set color only as uniform
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

  if(tex == current_target) { //current target goes down, ignore last write
    buffered_sprites = 0; //Trash pending batch, after all dst is destroyed
    current_target = nullptr;
  }

  if(tex == current_texture) {
    restart_batch(); //Quickly write the texture before it dies
    current_texture = nullptr;
  }

  tex->release(); // actually free texture memory
}

std::string GlRenderer::get_name() const {
  return std::string("GlRenderer"); //TODO
}

void GlRenderer::present(SDL_Window* window) {
  restart_batch(); //Draw last batch that could be 'stuck'
  SDL_GL_SwapWindow(window);
}

void GlRenderer::on_window_size_changed(const Rectangle& viewport) {
  if(!viewport.is_flat()) {
    window_viewport = viewport;
    screen_fbo.view = glm::ortho<float>(0,viewport.get_width(),viewport.get_height(),0);
  } else {
    Debug::warning("Ignoring zero area window size");
  }
}

const DrawProxy& GlRenderer::default_terminal() const {
  return static_cast<const DrawProxy&>(*main_shader.get());
}

GlRenderer::~GlRenderer() {
  if(Gl::use_vao()) {
    Gl::DeleteVertexArrays(1,&vao); //TODO delete rest
  }
  SDL_GL_DeleteContext(sdl_gl_context);
  instance = nullptr;
}

/**
 * @brief get a framebuffer from the framebuffer cache, given its size
 * @param width width of the framebuffer
 * @param height height of the framebuffer
 * @param screen desired buffer is the screen buffer?
 * @return a struct with the view matrix integrated
 */
GlRenderer::Fbo* GlRenderer::get_fbo(int width, int height, bool screen) {
  if(screen) return &screen_fbo;
  uint_fast64_t key =  (static_cast<uint_fast64_t>(width) << 32) | static_cast<uint_fast64_t>(height);
  int rw = key >> 32;
  int rh = key & 0xFFFFFFFF;
  Debug::check_assertion(rw == width,"recovered width does not match");
  Debug::check_assertion(rh == height,"recovered height does not match");
  auto it = fbos.find(key);
  if(it != fbos.end()) {
    return &it->second;
  }
  GLuint fbo;
  glGenFramebuffers(1,&fbo);
  glm::mat4 view = glm::ortho<float>(0,width,0,height);
  return &fbos.insert({key,{fbo,view}}).first->second;
}

/**
 * @brief number of indices in the buffer
 * @return
 */
size_t GlRenderer::buffered_indices() const {
  return buffered_sprites*6;
}

/**
 * @brief number of vertices in the buffer
 * @return
 */
size_t GlRenderer::buffered_vertices() const {
  return buffered_sprites*4;
}

/**
 * @brief restart the current batch, following a change of state or a full batch
 */
void GlRenderer::restart_batch() {
  if(current_target && buffered_sprites > 0) {
    //Stuff to render!
    if(test_texture != current_target) {
      Debug::warning("InCONSISTENT state");
    }
    glBufferSubData(GL_ARRAY_BUFFER, 0, buffered_vertices()*sizeof(Vertex), vertex_buffer.data());
    glDrawElements(GL_TRIANGLES, buffered_indices(), GL_UNSIGNED_SHORT, nullptr);
    //Orphan buffer to refill faster
    glBufferData(GL_ARRAY_BUFFER, vertex_buffer.size()*sizeof(Vertex), nullptr, GL_DYNAMIC_DRAW);

  }
  test_texture = nullptr;
  //Done rendering, start actual batch
  current_vertex = vertex_buffer.data();

  buffered_sprites = 0; //Reset sprite count, lets accumulate sprites!
}

/**
 * @brief Set the current shader
 * @param shader the shader
 */
void GlRenderer::set_shader(GlShader* shader) {
  if(shader != current_shader) {
    shader->bind();
    if(current_shader){
      current_shader->unbind();
    }
    current_shader = shader;
  }
}

/**
 * @brief rebind current shader
 */
void GlRenderer::rebind_shader() {
  if(current_shader) {
    current_shader->bind();
  }
}

/**
 * @brief Set the current texture
 * @param texture
 */
void GlRenderer::set_texture(const GlTexture *texture) {
  if(texture != current_texture) {
    //Change texture binding state
    current_texture = texture;
    rebind_texture();
  }
}

/**
 * @brief Bind current texture again, to restore state
 */
void GlRenderer::rebind_texture() {
  if(current_texture) { //Texture might be null if we want no texture for filling
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D,current_texture->get_texture());
  }
}

/**
 * @brief Set current state
 * @param src the texture to draw
 * @param shad the shader to use to draw
 * @param dst the texture to draw to
 * @param mode the blend mode to use
 */
void GlRenderer::set_state(const GlTexture *src, GlShader* shad, GlTexture* dst, const GLBlendMode& mode, bool force) {
  if(src != current_texture ||
     shad != current_shader ||
     dst != current_target ||
     mode != current_blend_mode ||
     force) { //Need to restart the batch!

    restart_batch(); //Draw current buffer if needed
    set_shader(shad);
    set_render_target(dst);
    set_texture(src);
    set_blend_mode(mode);

    if(!current_shader) return; //Dont upload uniform if there is no shader
    //Resend mvp and uvm
    glUniformMatrix4fv(current_shader->get_uniform_location(Shader::MVP_MATRIX_NAME),
                       1,
                       GL_FALSE,
                       glm::value_ptr(dst->fbo->view));
    if(current_texture) {
      glUniformMatrix3fv(current_shader->get_uniform_location(Shader::UV_MATRIX_NAME),
                         1,
                         GL_FALSE,
                         glm::value_ptr(current_texture->uv_transform));
      int sw = current_texture->get_width();
      int sh = current_texture->get_height();
      glUniform2f(
            current_shader->get_uniform_location(Shader::INPUT_SIZE_NAME),
            sw,sh);
    }

    if(current_target) {
      int dw = current_target->get_width();
      int dh = current_target->get_height();
      glUniform2f(
            current_shader->get_uniform_location(Shader::OUTPUT_SIZE_NAME),
            dw,dh);
    }
    glUniform1i(
          current_shader->get_uniform_location(Shader::TIME_NAME),
          System::now());
  }
}

/**
 * @brief Set the current blend mode
 * @param mode the mode
 */
void GlRenderer::set_blend_mode(GLBlendMode mode) {
  if(mode != current_blend_mode) {
    current_blend_mode = mode;
    GLenum srcRGB,dstRGB,srcA,dstA;
    bool alpha_mult;
    std::tie(srcRGB,dstRGB,srcA,dstA,alpha_mult) = mode;
    glBlendFuncSeparate(srcRGB,dstRGB,
                        srcA,dstA);

    if(current_shader) {
      glUniform1i(
            current_shader->get_uniform_location("sol_alpha_mult"),
            alpha_mult);
    }
  }
}

/**
 * @brief deduce a GLBlendMode for a src and dst pair and desired mode
 * @param dst destination texture
 * @param src source texture
 * @param mode desired blend mode
 * @return the GLBlendMode aggregate
 */
GlRenderer::GLBlendMode GlRenderer::make_gl_blend_modes(const GlTexture& dst, const GlTexture* src, BlendMode mode) {
  if(src && src->is_premultiplied() && dst.is_premultiplied()) {
    switch(mode) {
    case BlendMode::BLEND:
      return GLBlendMode{GL_ONE,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE_MINUS_SRC_ALPHA,true};
    case BlendMode::MULTIPLY:
      return GLBlendMode{GL_DST_COLOR,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE_MINUS_SRC_ALPHA,true};
    default:
      break;
    }
  } else if(dst.is_premultiplied() && mode == BlendMode::BLEND) {
    return GLBlendMode{GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE_MINUS_SRC_ALPHA,false};
  }
  return make_gl_blend_modes(mode);
}

/**
 * @brief make a GLBlendMode from a Solarus::BlendMode
 * @param mode the desired mode
 * @return the GLBlendMode aggregate
 */
GlRenderer::GLBlendMode GlRenderer::make_gl_blend_modes(BlendMode mode) {
  auto sym = [](GLenum src,GLenum dst) -> GLBlendMode {
    return GLBlendMode{src,dst,src,dst,false};
  };
  switch(mode) {
  case BlendMode::BLEND:
    return GLBlendMode{GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE,false};
  case BlendMode::MULTIPLY:
    return GLBlendMode{GL_DST_COLOR,GL_ZERO,GL_ONE,GL_ONE,false};
  case BlendMode::ADD:
    return sym(GL_ONE,GL_ONE);
  case BlendMode::NONE:
    return sym(GL_ONE,GL_ZERO);
  }
  return sym(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
}

/**
 * @brief Create the Gl buffers for this renderer
 * @param num_sprites maximum number of sprites to batch
 */
void GlRenderer::create_vbo(size_t num_sprites) {
  buffer_size = num_sprites;

  if(Gl::use_vao()) {
    Gl::GenVertexArrays(1,&vao); //TODO for android ifndef this
    Gl::BindVertexArray(vao);
  }

  glGenBuffers(1,&ibo);

  size_t indice_count = num_sprites*6;
  size_t vertex_count = num_sprites*4;



  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ibo);
  std::vector<GLushort> indices(indice_count);
  static constexpr std::array<GLushort,6> quad{{0,1,2,2,3,0}};
  for(size_t i = 0; i < num_sprites; i++) {
    size_t vbase = i*4;
    size_t ibase = i*6;
    for(size_t j = 0; j < quad.size(); j++) {
      indices[ibase+j] = vbase + quad[j];
    }
  }
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, indice_count*sizeof(GLushort), indices.data(), GL_STATIC_DRAW);

  //Give CPU side vertex buffer a size
  vertex_buffer.resize(vertex_count);

  //Create GPU side buffer storage
  glGenBuffers(1, &vbo);
  glBindBuffer(GL_ARRAY_BUFFER, vbo);

  glBufferData(GL_ARRAY_BUFFER, vertex_count*sizeof(Vertex), nullptr, GL_DYNAMIC_DRAW);
}

/**
 * @brief notify the renderer that a shader state (uniform or smth else) is about to change
 * @param shader the soon to be modified shader
 *
 * This is used to end a batch if the shader is modified while bound
 */
void GlRenderer::shader_about_to_change(GlShader* shader) {
  if(shader == current_shader) {
    restart_batch(); //Draw the sprites before shader state changes
  }
}

/**
 * @brief add a sprite with given draw info to the batch
 * @param infos the draw infos
 */
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
