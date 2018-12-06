/*
 * Copyright (C) 2006-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/core/Logger.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/System.h"
#include "solarus/core/Transform.h"
#include "solarus/graphics/sdlrenderer/SDLShader.h"
#include "solarus/graphics/sdlrenderer/SDLRenderer.h"
#include "solarus/graphics/sdlrenderer/SDLSurfaceImpl.h"
#include "solarus/graphics/Video.h"
#include "solarus/graphics/Surface.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"
#include "solarus/graphics/VertexArray.h"
#include "solarus/graphics/DefaultShaders.h"

#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/transform.hpp>
#include <glm/gtx/matrix_transform_2d.hpp>

namespace Solarus {

VertexArray SDLShader::screen_quad(TRIANGLES);

struct GlFunctions {
#define SDL_PROC(ret,func,params) ret (APIENTRY* func) params;
#include "../gles2funcs.h"
#undef SDL_PROC
};

namespace {
GlFunctions ctx;
}

/**
 * \brief Initializes the GL 2D shader system.
 * \return \c true if GL 2D shaders are supported.
 */
bool SDLShader::initialize() {
#if SDL_VIDEO_DRIVER_UIKIT || SDL_VIDEO_DRIVER_PANDORA
#define SDL_PROC(ret,func,params) ctx.func=func;
#else
#define SDL_PROC(ret,func,params) \
  do { \
  ctx.func = reinterpret_cast<APIENTRY ret(*)params>(SDL_GL_GetProcAddress(#func)); \
  if ( ! ctx.func ) { \
  Debug::warning(std::string("Couldn't load GLES2 function" #func)+  SDL_GetError()); \
  return false; \
} \
} while ( 0 );
#endif
#include "../gles2funcs.h"
#undef SDL_PROC

  //Init screen quad
  screen_quad.add_quad(Rectangle(0,0,1,1),Rectangle(0,1,1,-1),Color::white);

  Logger::info("Using modern GL Shaders");

  return true;
}

/**
 * \brief Uninitializes the GL shader system.
 */
void SDLShader::quit() {
}

/**
 * \brief Creates a shader from a shader resource file.
 * \param shader_name The name of the shader to load.
 */
SDLShader::SDLShader(const std::string& shader_id):
  Shader(shader_id),
  program(0),
  vertex_shader(0),
  fragment_shader(0) {
  compile();
}

/**
 * \brief Creates a shader from vertex and fragment source.
 * \param vertex_source Vertex shader code.
 * \param fragment_source Fragment shader code.
 */
SDLShader::SDLShader(const std::string& vertex_source,
               const std::string& fragment_source,
               double scaling_factor):
  Shader(vertex_source,fragment_source,scaling_factor),
  program(0),
  vertex_shader(0),
  fragment_shader(0) {
  compile();
}

/**
 * \brief Destructor.
 */
SDLShader::~SDLShader() {
  ctx.glDeleteShader(vertex_shader);
  ctx.glDeleteShader(fragment_shader);
  ctx.glDeleteProgram(program);
}

/**
 * \brief Compiles the shader program.
 */
void SDLShader::compile() {

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);

  ctx.glGetError();

  GLint linked;

  // Create the vertex and fragment shaders.
  vertex_shader = create_shader(GL_VERTEX_SHADER, get_vertex_source().c_str());
  fragment_shader = create_shader(GL_FRAGMENT_SHADER, get_fragment_source().c_str());

  // Create a program object with both shaders.
  program = ctx.glCreateProgram();
  if (program == 0) {
    Debug::error(std::string("Could not create OpenGL program"));
    return;
  }

  ctx.glAttachShader(program, vertex_shader);
  ctx.glAttachShader(program, fragment_shader);

  ctx.glLinkProgram(program);

  // Check GL status.
  ctx.glGetProgramiv(program, GL_LINK_STATUS, &linked);
  GLint info_len = 0;
  ctx.glGetProgramiv(program, GL_INFO_LOG_LENGTH, &info_len);

  if (info_len > 1) {
    std::string log;
    log.resize(info_len, '\0');
    ctx.glGetProgramInfoLog(program, info_len, NULL, &log[0]);
    Logger::info(std::string("Linking result of shader '") + get_id() + std::string("':\n") + log);
  }

  if (!linked) {
    Debug::error(std::string("Failed to link shader '") + get_id() + std::string("':\n"));
    ctx.glDeleteProgram(program);
  }

  ctx.glUseProgram(program);

  // Set up constant uniform variables.
  GLint location = ctx.glGetUniformLocation(program, TEXTURE_NAME);
  if (location >= 0) {
    ctx.glUniform1i(location, 0);
  }

  const Size& quest_size = Video::get_quest_size();
  location = ctx.glGetUniformLocation(program, INPUT_SIZE_NAME);
  if (location >= 0) {
    ctx.glUniform2f(location, quest_size.width, quest_size.height);
  }

  position_location = ctx.glGetAttribLocation(program, POSITION_NAME);
  tex_coord_location = ctx.glGetAttribLocation(program, TEXCOORD_NAME);
  color_location = ctx.glGetAttribLocation(program, COLOR_NAME);

  ctx.glUseProgram(previous_program);
}

/**
 * \brief Compile a shader from source.
 * \param type The type of the shader to fill and compile.
 * \param source Sources to compile.
 * \return The shader created and compiled.
 */
GLuint SDLShader::create_shader(GLenum type, const char* source) {

  GLint compiled;

  // Create the shader object.
  GLuint shader = ctx.glCreateShader(type);
  check_gl_error();

  if (shader == 0) {
    Debug::error("Could not create OpenGL shader");
    return shader;
  }

  ctx.glShaderSource(shader, 1, &source, NULL);
  ctx.glCompileShader(shader);

  // Check the compile status.
  std::string shader_type_string = (type == GL_VERTEX_SHADER) ?
        "vertex" : "fragment";
  ctx.glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
  GLint info_len = 0;
  ctx.glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &info_len);

  if (info_len > 1) {
    std::string log;
    log.resize(info_len, '\0');
    ctx.glGetShaderInfoLog(shader, info_len, NULL, &log[0]);
    Logger::info("Compilation result of " + shader_type_string + " shader '" + get_id() + "':\n" + log);
  }

  if (!compiled) {
    Debug::error("Failed to compile " + shader_type_string + " shader '" + get_id() + "'");
    ctx.glDeleteShader(shader);
    shader = 0;
  }

  return shader;
}

/**
 * \brief Check for a possible error returned by glGetError().
 */
void SDLShader::check_gl_error() {
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

/**
 * \copydoc Shader::render
 */
void SDLShader::render(const VertexArray& array, const Surface& texture, const glm::mat4 &mvp_matrix, const glm::mat3 &uv_matrix) {
  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);

  ctx.glDisable(GL_CULL_FACE);

  if(array.vertex_buffer == 0) {
    //Generate vertex-buffer
    ctx.glGenBuffers(1,&array.vertex_buffer);
  }
  GLint previous_buffer;
  ctx.glGetIntegerv(GL_ARRAY_BUFFER_BINDING,&previous_buffer);
  ctx.glBindBuffer(GL_ARRAY_BUFFER,array.vertex_buffer);
  if(array.buffer_dirty) {
    //Upload vertex buffer //TODO use glSubData if array size <= previous size
    ctx.glBufferData(GL_ARRAY_BUFFER,array.vertex_count()*sizeof(Vertex),array.data(),GL_DYNAMIC_DRAW);
    array.buffer_dirty = false;
  }
  ctx.glUniformMatrix4fv(get_uniform_location(Shader::MVP_MATRIX_NAME),1,GL_FALSE,glm::value_ptr(mvp_matrix));

  glm::mat3 uvm = uv_matrix;
  ctx.glUniformMatrix3fv(get_uniform_location(Shader::UV_MATRIX_NAME),1,GL_FALSE,glm::value_ptr(uvm));

  enable_attribute(position_location, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, position));
  enable_attribute(tex_coord_location, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, texcoords));
  enable_attribute(color_location, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(Vertex), (void*)offsetof(Vertex, color));

  ctx.glActiveTexture(GL_TEXTURE0 + 0);  // Texture unit 0.
  SDL_GL_BindTexture(texture.get_impl().as<SDLSurfaceImpl>().get_texture(), nullptr, nullptr);

  for (const auto& kvp : uniform_textures) {
    const GLuint texture_unit = kvp.second.unit;
    ctx.glActiveTexture(GL_TEXTURE0 + texture_unit);
    SDL_GL_BindTexture(kvp.second.surface->get_impl().as<SDLSurfaceImpl>().get_texture(),nullptr,nullptr);
  }

  ctx.glDrawArrays((GLenum)array.get_primitive_type(),0,array.vertex_count());

  restore_attribute_states();

  for (const auto& kvp : uniform_textures) {
    const GLuint texture_unit = kvp.second.unit;
    ctx.glActiveTexture(GL_TEXTURE0 + texture_unit);
    SDL_GL_UnbindTexture(kvp.second.surface->get_impl().as<SDLSurfaceImpl>().get_texture());
  }

  ctx.glActiveTexture(GL_TEXTURE0);

  ctx.glBindBuffer(GL_ARRAY_BUFFER,previous_buffer);
  ctx.glUseProgram(previous_program);
}



/**
 * \brief Returns the location of a uniform value in the shader program.
 * \param uniform_name Name of the uniform to find.
 * \return The uniform location or \c -1.
 */
GLint SDLShader::get_uniform_location(const std::string& uniform_name) const {
  const auto& it = uniform_locations.find(uniform_name);
  if (it != uniform_locations.end()) {
    return it->second;
  }

  const GLint location = ctx.glGetUniformLocation(program, uniform_name.c_str());
  uniform_locations.insert(std::make_pair(uniform_name, location));
  return location;
}

/**
 * \copydoc Shader::set_uniform1f
 */
void SDLShader::set_uniform_1b(const std::string& uniform_name, bool value) {

  const GLint location = get_uniform_location(uniform_name);
  if (location == -1) {
    return;
  }

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);
  ctx.glUniform1i(location, (value ? 1 : 0));
  ctx.glUseProgram(previous_program);
}

/**
 * \copydoc Shader::set_uniform_1i
 */
void SDLShader::set_uniform_1i(const std::string& uniform_name, int value) {

  const GLint location = get_uniform_location(uniform_name);
  if (location == -1) {
    return;
  }

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);
  ctx.glUniform1i(location, value);
  ctx.glUseProgram(previous_program);
}

/**
 * \copydoc Shader::set_uniform_1f
 */
void SDLShader::set_uniform_1f(const std::string& uniform_name, float value) {

  const GLint location = get_uniform_location(uniform_name);
  if (location == -1) {
    return;
  }

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);
  ctx.glUniform1f(location, value);
  ctx.glUseProgram(previous_program);
}

/**
 * \copydoc Shader::set_uniform_2f
 */
void SDLShader::set_uniform_2f(const std::string& uniform_name, float value_1, float value_2) {

  const GLint location = get_uniform_location(uniform_name);
  if (location == -1) {
    return;
  }

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);
  ctx.glUniform2f(location, value_1, value_2);
  ctx.glUseProgram(previous_program);
}

/**
 * \copydoc Shader::set_uniform_3f
 */
void SDLShader::set_uniform_3f(
    const std::string& uniform_name, float value_1, float value_2, float value_3) {

  const GLint location = get_uniform_location(uniform_name);
  if (location == -1) {
    return;
  }

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);
  ctx.glUniform3f(location, value_1, value_2, value_3);
  ctx.glUseProgram(previous_program);
}

/**
 * \copydoc Shader::set_uniform_4f
 */
void SDLShader::set_uniform_4f(
    const std::string& uniform_name, float value_1, float value_2, float value_3, float value_4) {

  const GLint location = get_uniform_location(uniform_name);
  if (location == -1) {
    return;
  }

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);
  ctx.glUniform4f(location, value_1, value_2, value_3, value_4);
  ctx.glUseProgram(previous_program);
}

/**
 * \copydoc Shader::set_uniform_texture
 */
bool SDLShader::set_uniform_texture(const std::string& uniform_name, const SurfacePtr& value) {
  const GLint location = get_uniform_location(uniform_name);

  if (location == -1) {
    // Not an error.
    return true;
  }

  auto it = uniform_textures.find(uniform_name);
  if(it != uniform_textures.end()) {
    it->second.surface = value;
    return true; //Nothing else to do
  }
  //else find a new texture unit

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);
  ctx.glUseProgram(program);

  int texture_unit = ++current_texture_unit;
  uniform_textures[uniform_name] = TextureUniform{value,(GLuint)texture_unit};

  ctx.glUniform1i(location, texture_unit);

  ctx.glUseProgram(previous_program);
  return true;
}

/**
 * \brief Enable the attribute and keep trace of the old state.
 * \param index The index of the vertex attribute.
 * \param size The number of components per vertex attribute.
 * \param type The data type of each component in the array.
 * \param normalized Specifies whether fixed-point data values should be normalized.
 * \param stride The byte offset between consecutive generic vertex attributes.
 * \param pointer Specifies a offset of the first component of the first generic
 * vertex attribute in the array in the data store of the buffer currently bound
 * to the GL_ARRAY_BUFFER target.
 */
void SDLShader::enable_attribute(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* pointer) {

  GLint previous_state;
  // TODO Check if the get step can be done once at the initialization time.
  ctx.glGetVertexAttribiv(index, GL_VERTEX_ATTRIB_ARRAY_ENABLED, &previous_state);
  ctx.glEnableVertexAttribArray(index);
  ctx.glVertexAttribPointer(index, size, type, normalized, stride, pointer);
  attribute_states.insert(std::make_pair(index, previous_state));
}

/**
 * \brief Restore previous attrib states.
 */
void SDLShader::restore_attribute_states() {

  for (const auto& attrib : attribute_states) {
    if(!attrib.second)
      ctx.glDisableVertexAttribArray(attrib.first);
  }
  attribute_states.clear();
}

void SDLShader::compute_matrices(const Size& surface_size, const Rectangle& region, const Size& dst_size, const Point& dst_position, bool flip_y,
                                     glm::mat4& viewport, glm::mat4& dst, glm::mat4& scale, glm::mat3 &uvm) {

  viewport = glm::ortho<float>(0,dst_size.width,0,dst_size.height); //Specify float as type to avoid integral division
  dst = glm::translate(glm::mat4(),glm::vec3(dst_position.x,dst_position.y,0));
  scale = glm::scale(glm::mat4(),glm::vec3(region.get_width(),region.get_height(),1));

  float uxf = 1.f/surface_size.width;
  float uyf = 1.f/surface_size.height;

  glm::mat3 uv_scale = glm::scale(
        glm::mat3(1),
        glm::vec2(
          region.get_width()*uxf,
          region.get_height()*uyf
          )
        );
  glm::mat3 uv_trans = glm::translate(glm::mat3(),glm::vec2(region.get_left()*uxf,region.get_top()*uyf));
  uvm = uv_trans*uv_scale;
  if(!flip_y){
    uvm = glm::scale(uvm,glm::vec2(1,-1));
    uvm = glm::translate(uvm,glm::vec2(0,-1));
  }
}

/**
 * @brief Render given surface on currently bound rendertarget
 * @param surface surface to draw
 * @param region region of the src surface to draw
 * @param dst_size size of the destination surface
 * @param dst_position position where to draw surface on destination
 * @param flip_y flip the drawing upside-down
 */
void SDLShader::render(const Surface &surface, const Rectangle& region, const Size& dst_size, const Point & dst_position, bool flip_y) {
  //TODO compute mvp and uv_matrix here
  glm::mat4 viewport,dst,scale;
  glm::mat3 uvm;
  compute_matrices(surface.get_size(),region,dst_size,dst_position,flip_y,viewport,dst,scale,uvm);
  //Set input size
  const Size& size = flip_y ? Video::get_output_size() : dst_size;
  set_uniform_1i(Shader::TIME_NAME, System::now());
  set_uniform_2f(Shader::OUTPUT_SIZE_NAME, size.width, size.height);
  set_uniform_2f(Shader::INPUT_SIZE_NAME, region.get_width(), region.get_height());
  render(screen_quad,surface,viewport*dst*scale,uvm);
}

void SDLShader::draw(Surface& dst_surface, const Surface &src_surface, const DrawInfos &infos) const {
    SDLRenderer::get().set_render_target(dst_surface.get_impl().as<SDLSurfaceImpl>().get_texture());
    auto r = SDLRenderer::get().renderer;
    SDL_BlendMode target = SDLRenderer::get().make_sdl_blend_mode(dst_surface.get_impl(),
                                              src_surface.get_impl(),
                                              infos.blend_mode); //TODO fix alpha premult here
    SDL_BlendMode current;
    SDL_GetRenderDrawBlendMode(r,&current);
    if(target != current) { //Blend mode need change
      SDL_SetRenderDrawBlendMode(r,target);
      SDL_RenderDrawPoint(r,-100,-100); //Draw a point offscreen to force blendmode change
    }

    bool flip_y = !dst_surface.get_impl().as<SDLSurfaceImpl>().get_texture();

    //TODO fix this ugliness
    auto that = const_cast<SDLShader*>(this);
    that->set_uniform_1f(OPACITY_NAME,infos.opacity/255.f);
    //TODO compute mvp and uv_matrix here

    const auto& region = infos.region;
    auto dst_position = infos.dst_position;

    Size dst_size = dst_surface.get_size();
    glm::mat4 viewport,dst,scale;
    glm::mat3 uvm;
    compute_matrices(src_surface.get_size(),region,dst_size,dst_position,
                     flip_y,
                     viewport,dst,scale,uvm);
    glm::mat4 transform = Transform(dst_position,infos.transformation_origin,infos.scale,infos.rotation).get_glm_transform() * scale;
    //Set input size
    const Size& size = dst_size;
    that->set_uniform_1i(Shader::TIME_NAME, System::now());
    that->set_uniform_2f(Shader::OUTPUT_SIZE_NAME, size.width, size.height);
    that->set_uniform_2f(Shader::INPUT_SIZE_NAME, region.get_width(), region.get_height());
    that->render(screen_quad,src_surface,viewport*transform,uvm);
}

}
