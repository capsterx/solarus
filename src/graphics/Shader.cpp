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
#include "solarus/graphics/Shader.h"
#include "solarus/graphics/Video.h"
#include "solarus/graphics/Surface.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"
#include "solarus/graphics/VertexArray.h"
#include "solarus/graphics/RenderTexture.h"

#include "solarus/third_party/glm/gtc/type_ptr.hpp"
#include "solarus/third_party/glm/gtx/transform.hpp"
#include "solarus/third_party/glm/gtx/matrix_transform_2d.hpp"

namespace Solarus {

VertexArray Shader::screen_quad(TRIANGLES);

constexpr auto DEFAULT_VERTEX =
    R"(
    #if __VERSION__ >= 130
    #define COMPAT_VARYING out
    #define COMPAT_ATTRIBUTE in
    #else
    #define COMPAT_VARYING varying
    #define COMPAT_ATTRIBUTE attribute
    #endif

    #ifdef GL_ES
    precision mediump float;
    #define COMPAT_PRECISION mediump
    #else
    #define COMPAT_PRECISION
    #endif

    uniform mat4 sol_mvp_matrix;
    uniform mat3 sol_uv_matrix;
    COMPAT_ATTRIBUTE vec2 sol_vertex;
    COMPAT_ATTRIBUTE vec2 sol_tex_coord;
    COMPAT_ATTRIBUTE vec4 sol_color;

    COMPAT_VARYING vec2 sol_vtex_coord;
    COMPAT_VARYING vec4 sol_vcolor;
    void main() {
      gl_Position = sol_mvp_matrix * vec4(sol_vertex,0,1);
      sol_vcolor = sol_color;
      sol_vtex_coord = (sol_uv_matrix * vec3(sol_tex_coord,1)).xy;
    }
    )";

constexpr auto DEFAULT_FRAGMENT =
    R"(
    #if __VERSION__ >= 130
    #define COMPAT_VARYING in
    #define COMPAT_TEXTURE texture
    out vec4 FragColor;
    #else
    #define COMPAT_VARYING varying
    #define FragColor gl_FragColor
    #define COMPAT_TEXTURE texture2D
    #endif

    #ifdef GL_ES
    precision mediump float;
    #define COMPAT_PRECISION mediump
    #else
    #define COMPAT_PRECISION
    #endif

    uniform sampler2D sol_texture;
    COMPAT_VARYING vec2 sol_vtex_coord;
    COMPAT_VARYING vec4 sol_vcolor;
    void main() {
      vec4 tex_color = COMPAT_TEXTURE(sol_texture,sol_vtex_coord);
      FragColor = tex_color*sol_vcolor;
    }
    )";

struct GlContext {
#define SDL_PROC(ret,func,params) ret (APIENTRY* func) params;
#include "gles2funcs.h"
#undef SDL_PROC
};

namespace {
GlContext ctx;
}

/**
 * \brief Initializes the GL 2D shader system.
 * \return \c true if GL 2D shaders are supported.
 */
bool Shader::initialize() {
#if SDL_VIDEO_DRIVER_UIKIT || SDL_VIDEO_DRIVER_ANDROID || SDL_VIDEO_DRIVER_PANDORA
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
#include "gles2funcs.h"
#undef SDL_PROC


  //Init screen quad
  screen_quad.add_quad(Rectangle(0,0,1,1),Rectangle(0,1,1,-1),Color::white);

  Logger::info("Using modern GL Shaders");

  return true;
}

/**
 * \brief Constructor.
 * \param shader_name The name of the shader to load.
 */
Shader::Shader(const std::string& shader_id):
  shader_id(shader_id),
  data(),
  valid(true),
  error(),
  program(0),
  vertex_shader(0),
  fragment_shader(0) {

  GLint previous_program;
  ctx.glGetIntegerv(GL_CURRENT_PROGRAM, &previous_program);

  ctx.glGetError();

  // Load the shader.
  load();

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

  position_location = ctx.glGetAttribLocation(program,POSITION_NAME);
  tex_coord_location = ctx.glGetAttribLocation(program,TEXCOORD_NAME);
  color_location = ctx.glGetAttribLocation(program,COLOR_NAME);

  ctx.glUseProgram(previous_program);
}

/**
 * \brief Destructor.
 */
Shader::~Shader() {
  ctx.glDeleteShader(vertex_shader);
  ctx.glDeleteShader(fragment_shader);
  ctx.glDeleteProgram(program);
}

/**
 * \copydoc Shader::load
 */
void Shader::load() {

  GLint linked;

  // Load the shader data file.
  const std::string shader_file_name =
      "shaders/" + get_id() + ".dat";

  ShaderData data;
  bool success = data.import_from_quest_file(shader_file_name);
  if (!success) {
    return;
  }

  set_data(data);

  // Create the vertex and fragment shaders.
  vertex_shader = create_shader(GL_VERTEX_SHADER, get_vertex_source().c_str());
  fragment_shader = create_shader(GL_FRAGMENT_SHADER, get_fragment_source().c_str());

  // Create a program object with both shaders.
  program = ctx.glCreateProgram();
  if (program == 0) {
    Logger::error(std::string("Could not create OpenGL program"));
    return;
  }

  ctx.glAttachShader(program, vertex_shader);
  ctx.glAttachShader(program, fragment_shader);

  ctx.glLinkProgram(program);

  // Check GL status.
  ctx.glGetProgramiv(program, GL_LINK_STATUS, &linked);

  if (!linked) {
    GLint info_len = 0;
    ctx.glGetProgramiv(program, GL_INFO_LOG_LENGTH, &info_len);

    if (info_len > 1) {
      char* info = (char*)malloc(sizeof(char) * info_len);
      ctx.glGetProgramInfoLog(program, info_len, NULL, info);
      Logger::error(std::string("Failed to link shader ") + get_id() + std::string(" :\n") + info);
      free(info);
    }

    ctx.glDeleteProgram(program);
  }
}

/**
 * \brief Compile a shader from source.
 * \param type The type of the shader to fill and compile.
 * \param source Sources to compile.
 * \return The shader created and compiled.
 */
GLuint Shader::create_shader(GLenum type, const char* source) {

  GLint compiled;

  // Create the shader object.
  GLuint shader = ctx.glCreateShader(type);
  check_gl_error();

  if(shader == 0) {
    Logger::error(std::string("Could not create OpenGL shader "));
    return shader;
  }

  ctx.glShaderSource(shader, 1, &source, NULL);
  ctx.glCompileShader(shader);

  // Check the compile status.
  ctx.glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);

  if(!compiled) {
    GLint info_len = 0;

    ctx.glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &info_len);

    if(info_len > 1) {
      char* info = (char*)malloc(sizeof(char) * info_len);
      ctx.glGetShaderInfoLog(shader, info_len, NULL, info);
      Logger::error(std::string("Failed to compile shader '") + get_id() + std::string("':\n") + info);
      free(info);
    }

    ctx.glDeleteShader(shader);
    shader = 0;
  }

  return shader;
}

/**
 * \brief Check for a possible error returned by glGetError().
 */
void Shader::check_gl_error() {
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

    Logger::error(std::string("GL_") + error.c_str() + std::string(" - "));
    gl_error = ctx.glGetError();
  }
}

std::string Shader::default_vertex_source() const {
  return DEFAULT_VERTEX;
}

std::string Shader::default_fragment_source() const {
  return DEFAULT_FRAGMENT;
}

/**
 * \copydoc Shader::render
 */
void Shader::render(const VertexArray& array, const Surface& texture, const glm::mat4 &mvp_matrix, const glm::mat3 &uv_matrix) {
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
  SDL_GL_BindTexture(texture.get_internal_surface().get_texture(), nullptr, nullptr);

  for (const auto& kvp : uniform_textures) {
    const GLuint texture_unit = kvp.second.unit;
    ctx.glActiveTexture(GL_TEXTURE0 + texture_unit);
    SDL_GL_BindTexture(kvp.second.surface->get_internal_surface().get_texture(),nullptr,nullptr);

    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  }

  ctx.glDrawArrays((GLenum)array.get_primitive_type(),0,array.vertex_count());

  restore_attribute_states();

  for (const auto& kvp : uniform_textures) {
    const GLuint texture_unit = kvp.second.unit;
    ctx.glActiveTexture(GL_TEXTURE0 + texture_unit);
    SDL_GL_UnbindTexture(kvp.second.surface->get_internal_surface().get_texture());
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
GLint Shader::get_uniform_location(const std::string& uniform_name) const {
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
void Shader::set_uniform_1b(const std::string& uniform_name, bool value) {

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
void Shader::set_uniform_1i(const std::string& uniform_name, int value) {

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
void Shader::set_uniform_1f(const std::string& uniform_name, float value) {

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
void Shader::set_uniform_2f(const std::string& uniform_name, float value_1, float value_2) {

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
void Shader::set_uniform_3f(
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
void Shader::set_uniform_4f(
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
bool Shader::set_uniform_texture(const std::string& uniform_name, const SurfacePtr& value) {
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
void Shader::enable_attribute(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* pointer) {

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
void Shader::restore_attribute_states() {

  for (const auto& attrib : attribute_states) {
    if(!attrib.second)
      ctx.glDisableVertexAttribArray(attrib.first);
  }
  attribute_states.clear();
}

/**
 * \brief Returns whether this shader is valid.
 * \return \c true if the shader was successfully loaded.
 */
bool Shader::is_valid() const {
  return valid;
}

/**
 * \brief Sets whether this shader is valid.
 * \param valid \c true to indicate that the shader was successfully loaded.
 */
void Shader::set_valid(bool valid) {
  this->valid = valid;
}

/**
 * \brief Returns the error message of the last operation if any.
 * \return The error message or an empty string.
 */
std::string Shader::get_error() const {
  return error;
}

/**
 * \brief Sets the error message of the last operation.
 *
 * There should be an error message when \c is_valid() returns \c false.
 *
 * \param error The error message or an empty string.
 */
void Shader::set_error(const std::string& error) {
  this->error = error;
}

/**
 * \brief Returns the id of the shader.
 * \return The id of the shader.
 */
const std::string& Shader::get_id() const {

  return shader_id;
}

/**
 * \brief Returns the shader information loaded from the data file.
 * \return The shader data.
 */
const ShaderData& Shader::get_data() const {
  return data;
}

/**
 * \brief Sets the shader information.
 * \param data The shader data.
 */
void Shader::set_data(const ShaderData& data) {
  this->data = data;
}

/**
 * @brief Returns the vertex source of the data or the default vertex source.
 * @return The vertex source.
 */
std::string Shader::get_vertex_source() const {

  if (!get_data().get_vertex_file().empty()) {
    const std::string& file_name = "shaders/" + get_data().get_vertex_file();
    if (QuestFiles::data_file_exists(file_name)) {
      return QuestFiles::data_file_read(file_name);
    }
    Logger::error("Cannot find vertex shader file '" + file_name + "'");
  }
  return default_vertex_source();
}

/**
 * @brief Returns the fragment source of the data or the default fragment source.
 * @return The fragment source.
 */
std::string Shader::get_fragment_source() const {

  if (!get_data().get_fragment_file().empty()) {
    const std::string& file_name = "shaders/" + get_data().get_fragment_file();
    if (QuestFiles::data_file_exists(file_name)) {
      return QuestFiles::data_file_read(file_name);
    }
    Logger::error("Cannot find fragment shader file '" + file_name + "'");
  }
  return default_fragment_source();
}

/**
 * \brief Returns the scaling factor of this shader.
 * \return The scaling factor (0.0 means none).
 */
double Shader::get_scaling_factor() const {
  return data.get_scaling_factor();
}

/**
 * \brief Sets the scaling factor of this shader.
 * \param scaling_factor The scaling factor (0.0 means none).
 */
void Shader::set_scaling_factor(double scaling_factor) {
  data.set_scaling_factor(scaling_factor);
}

void Shader::compute_matrices(const Size& surface_size, const Rectangle& region, const Size& dst_size, const Point& dst_position, bool flip_y,
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
void Shader::render(const Surface& surface, const Rectangle& region, const Size& dst_size, const Point & dst_position, bool flip_y) {
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

void Shader::draw(Surface& dst_surface, const Surface &src_surface, const DrawInfos &infos) const {
    dst_surface.request_render().with_target([&](SDL_Renderer* r){
      SDL_BlendMode target = Surface::make_sdl_blend_mode(dst_surface.get_internal_surface(),
                                                          src_surface.get_internal_surface(),
                                                          infos.blend_mode); //TODO fix alpha premult here
      SDL_BlendMode current;
      SDL_GetRenderDrawBlendMode(r,&current);
      if(target != current) { //Blend mode need change
        SDL_SetRenderDrawBlendMode(r,target);
        SDL_RenderDrawPoint(r,-100,-100); //Draw a point offscreen to force blendmode change
      }

      bool flip_y =  !dst_surface.get_internal_surface().get_texture();

      //TODO fix this ugliness
      Shader* that = const_cast<Shader*>(this);
      that->set_uniform_1f(OPACITY_NAME,infos.opacity/255.f);
      //TODO compute mvp and uv_matrix here

      const auto& region = infos.region;
      auto dst_position = flip_y ?
            Point(infos.dst_position.x,dst_surface.get_height()-infos.dst_position.y-region.get_height()) :
            infos.dst_position;

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
    });
}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& Shader::get_lua_type_name() const {
  return LuaContext::shader_module_name;
}

}
