/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
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
#include "solarus/graphics/glrenderer/GlShader.h"
#include "solarus/graphics/glrenderer/GlRenderer.h"
#include "solarus/graphics/glrenderer/GlTexture.h"
#include "solarus/graphics/Video.h"
#include "solarus/graphics/Surface.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"
#include "solarus/graphics/VertexArray.h"
#include "solarus/graphics/DefaultShaders.h"

#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/transform.hpp>
#include <glm/gtx/matrix_transform_2d.hpp>

#include <algorithm>
#include <sstream>

namespace Solarus {

namespace {
std::string version_string;
}

/**
 * \brief Initializes the GL 2D shader system.
 * \return \c true if GL 2D shaders are supported.
 */
bool GlShader::initialize() {
  Logger::info("Using modern GL Shaders");

  setup_version_string();

  return true;
}

/**
 * \brief Uninitializes the GL shader system.
 */
void GlShader::quit() {
}

/**
 * \brief Creates a shader from a shader resource file.
 * \param shader_name The name of the shader to load.
 */
GlShader::GlShader(const std::string& shader_id):
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
GlShader::GlShader(const std::string& vertex_source,
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
GlShader::~GlShader() {
  glDeleteShader(vertex_shader);
  glDeleteShader(fragment_shader);
  glDeleteProgram(program);
}

/**
 * \brief Compiles the shader program.
 */
void GlShader::compile() {
  GLint linked;

  // Create the vertex and fragment shaders.
  vertex_shader = create_shader(GL_VERTEX_SHADER, get_sanitized_vertex_source().c_str());
  fragment_shader = create_shader(GL_FRAGMENT_SHADER, get_sanitized_fragment_source().c_str());

  // Create a program object with both shaders.
  program = glCreateProgram();
  if (program == 0) {
    Debug::error(std::string("Could not create OpenGL program"));
    return;
  }

  glAttachShader(program, vertex_shader);
  glAttachShader(program, fragment_shader);

  glLinkProgram(program);

  // Check GL status.
  glGetProgramiv(program, GL_LINK_STATUS, &linked);
  GLint info_len = 0;
  glGetProgramiv(program, GL_INFO_LOG_LENGTH, &info_len);

  if (info_len > 1) {
    std::string log;
    log.resize(info_len, '\0');
    glGetProgramInfoLog(program, info_len, nullptr, &log[0]);
    Logger::info(std::string("Linking result of shader '") + get_id() + std::string("':\n") + log);
  }

  if (!linked) {
    Debug::error(std::string("Failed to link shader '") + get_id() + std::string("':\n"));
    glDeleteProgram(program);
    return;
  }

  set_valid(true);

  glUseProgram(program);

  // Set up constant uniform variables.
  GLint location = glGetUniformLocation(program, TEXTURE_NAME);
  if (location >= 0) {
    glUniform1i(location, 0);
  }

  const Size& quest_size = Video::get_quest_size();
  location = glGetUniformLocation(program, INPUT_SIZE_NAME);
  if (location >= 0) {
    glUniform2f(location, quest_size.width, quest_size.height);
  }

  position_location = glGetAttribLocation(program, POSITION_NAME);
  tex_coord_location = glGetAttribLocation(program, TEXCOORD_NAME);
  color_location = glGetAttribLocation(program, COLOR_NAME);

  //glUseProgram(previous_program);
  GlRenderer::get().rebind_shader();
}

/**
 * \brief Compile a shader from source.
 * \param type The type of the shader to fill and compile.
 * \param source Sources to compile.
 * \return The shader created and compiled.
 */
GLuint GlShader::create_shader(GLenum type, const char* source) {

  GLint compiled;

  // Create the shader object.
  GLuint shader = glCreateShader(type);
  //GlRenderer::check_gl_error(__FILE__,"undef");

  if (shader == 0) {
    Debug::error("Could not create OpenGL shader");
    return shader;
  }

  glShaderSource(shader, 1, &source, nullptr);
  glCompileShader(shader);

  // Check the compile status.
  std::string shader_type_string = (type == GL_VERTEX_SHADER) ?
        "vertex" : "fragment";
  glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
  GLint info_len = 0;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &info_len);

  if (info_len > 1) {
    std::string log;
    log.resize(info_len, '\0');
    glGetShaderInfoLog(shader, info_len, nullptr, &log[0]);
    Logger::info("Compilation result of " + shader_type_string + " shader '" + get_id() + "':\n" + log);
  }

  if (!compiled) {
    Debug::error("Failed to compile " + shader_type_string + " shader '" + get_id() + "'");
    glDeleteShader(shader);
    shader = 0;
  }

  return shader;
}

void GlShader::bind() {
  glUseProgram(program); //TODO check if this can be done only once
  bound = true;

  //Upload uniforms that were postponed
  for(const auto& u : pending_uniforms){
    upload_uniform(u);
  }
  pending_uniforms.clear();

  //Enable and paramatrize vertex attributes
  if(position_location != -1) {
    glEnableVertexAttribArray(position_location);
    glVertexAttribPointer(position_location,2,GL_FLOAT,GL_FALSE,sizeof(Vertex),
                               reinterpret_cast<void*>(offsetof(Vertex,position)));
  }
  if(tex_coord_location != -1) {
    glEnableVertexAttribArray(tex_coord_location);
    glVertexAttribPointer(tex_coord_location,2,GL_FLOAT,GL_FALSE, sizeof(Vertex),
                               reinterpret_cast<void*>(offsetof(Vertex,texcoords)));
  }
  if(color_location != -1) {
    glEnableVertexAttribArray(color_location);
    glVertexAttribPointer(color_location,4,GL_UNSIGNED_BYTE,GL_TRUE,sizeof(Vertex),
                               reinterpret_cast<void*>(offsetof(Vertex,color)));
  }

  //Bind correct uniform textures
  for(const auto& kvp : uniform_textures) {
    const GLuint texture_unit = kvp.second.unit;
    glActiveTexture(GL_TEXTURE0 + texture_unit);
    glBindTexture(GL_TEXTURE_2D,kvp.second.surface->get_impl().as<GlTexture>().get_texture());
  }
}

void GlShader::unbind() {
  bound = false; //Pretend we are unbound
}

/**
 * \brief Returns the location of a uniform value in the shader program.
 * \param uniform_name Name of the uniform to find.
 * \return The uniform location or \c -1.
 */
GLint GlShader::get_uniform_location(const std::string& uniform_name) const {
  const auto& it = uniform_locations.find(uniform_name);
  if (it != uniform_locations.end()) {
    return it->second;
  }

  const GLint location = glGetUniformLocation(program, uniform_name.c_str());
  uniform_locations.insert(std::make_pair(uniform_name, location));
  return location;
}

void GlShader::set_uniform(const Uniform& uniform) {
  if(!bound){
    pending_uniforms.push_back(uniform);
  } else {
    upload_uniform(uniform);
  }
}

void GlShader::draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& infos) const {
  GlRenderer::get().draw(dst_surface.get_impl(),src_surface.get_impl(),infos,const_cast<GlShader&>(*this));
}

void GlShader::upload_uniform(const Uniform& u) {
  Debug::check_assertion(bound,"Trying to set uniform on an unbound shader");
  GlRenderer::get().shader_about_to_change(this); //Notify renderer that batch must be interupted
  GLint loc = get_uniform_location(u.name);
  if(loc == -1) {
    return; //Not an error, no uniform to set
  }
  using T = Uniform::Type;
  switch(u.t) {
    case T::U1B:
      return glUniform1i(loc,u.b);
    case T::U1I:
      return glUniform1i(loc,u.i);
    case T::U1F:
      return glUniform1f(loc,u.f);
    case T::U2F:
      return glUniform2f(loc,u.ff.x,u.ff.y);
    case T::U3F:
      return glUniform3f(loc,u.fff.x,u.fff.y,u.fff.z);
    case T::U4F:
      return glUniform4f(loc,u.ffff.x,u.ffff.y,u.ffff.z,u.ffff.w);
  }
}

using UT = GlShader::Uniform::Type;
/**
 * \copydoc Shader::set_uniform1f
 */
void GlShader::set_uniform_1b(const std::string& uniform_name, bool value) {
  set_uniform(Uniform(uniform_name,value));
}


/**
 * \copydoc Shader::set_uniform_1i
 */
void GlShader::set_uniform_1i(const std::string& uniform_name, int value) {
  set_uniform(Uniform(uniform_name,value));
}

/**
 * \copydoc Shader::set_uniform_1f
 */
void GlShader::set_uniform_1f(const std::string& uniform_name, float value) {
  set_uniform(Uniform(uniform_name,value));
}

/**
 * \copydoc Shader::set_uniform_2f
 */
void GlShader::set_uniform_2f(const std::string& uniform_name, float value_1, float value_2) {
  set_uniform(Uniform(uniform_name,{value_1,value_2}));
}

/**
 * \copydoc Shader::set_uniform_3f
 */
void GlShader::set_uniform_3f(
    const std::string& uniform_name, float value_1, float value_2, float value_3) {
  set_uniform(Uniform(uniform_name,{value_1,value_2,value_3}));
}

/**
 * \copydoc Shader::set_uniform_4f
 */
void GlShader::set_uniform_4f(
    const std::string& uniform_name, float value_1, float value_2, float value_3, float value_4) {
  set_uniform(Uniform(uniform_name,{value_1,value_2,value_3,value_4}));
}

/**
 * \copydoc Shader::set_uniform_texture
 */
bool GlShader::set_uniform_texture(const std::string& uniform_name, const SurfacePtr& value) {
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

  GLuint texture_unit = ++current_texture_unit;
  uniform_textures[uniform_name] = TextureUniform{value,texture_unit};

  set_uniform(Uniform(uniform_name,(int)texture_unit));
  return true;
}

}
