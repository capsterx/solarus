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
#include "solarus/graphics/DefaultShaders.h"

#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/transform.hpp>
#include <glm/gtx/matrix_transform_2d.hpp>

namespace Solarus {

/**
 * \brief Creates a shader from a shader resource file.
 * \param shader_name The name of the shader to load.
 */
Shader::Shader(const std::string& shader_id):
  shader_id(shader_id),
  data(),
  vertex_source(),
  fragment_source(),
  valid(true),
  error() {

  // Load the shader data file.
  const std::string shader_file_name =
      "shaders/" + get_id() + ".dat";

  ShaderData data;
  bool success = data.import_from_quest_file(shader_file_name);
  if (!success) {
    return;
  }

  if (!data.get_vertex_file().empty()) {
    const std::string& file_name = "shaders/" + data.get_vertex_file();
    if (QuestFiles::data_file_exists(file_name)) {
      vertex_source = QuestFiles::data_file_read(file_name);
    }
    else {
      Debug::error("Cannot find vertex shader file '" + file_name + "'");
    }
  }
  if (!data.get_fragment_file().empty()) {
    const std::string& file_name = "shaders/" + data.get_fragment_file();
    if (QuestFiles::data_file_exists(file_name)) {
      fragment_source = QuestFiles::data_file_read(file_name);
    }
    else {
      Debug::error("Cannot find fragment shader file '" + file_name + "'");
    }
  }

  set_data(data);
}

/**
 * \brief Creates a shader from vertex and fragment source.
 * \param vertex_source Vertex shader code.
 * \param fragment_source Fragment shader code.
 */
Shader::Shader(const std::string& vertex_source,
               const std::string& fragment_source,
               double scaling_factor):
  shader_id(),
  data(),
  vertex_source(vertex_source),
  fragment_source(fragment_source),
  valid(true),
  error() {
  data.set_scaling_factor(scaling_factor);
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

  if (!vertex_source.empty()) {
    return vertex_source;
  }
  return DefaultShaders::get_default_vertex_source();
}

/**
 * @brief Returns the fragment source of the data or the default fragment source.
 * @return The fragment source.
 */
std::string Shader::get_fragment_source() const {

  if (!fragment_source.empty()) {
    return fragment_source;
  }
  return DefaultShaders::get_default_fragment_source();
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

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& Shader::get_lua_type_name() const {
  return LuaContext::shader_module_name;
}

}
