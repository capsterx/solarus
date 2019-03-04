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
#ifndef SOLARUS_SHADER_H
#define SOLARUS_SHADER_H

#include "solarus/core/Common.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/BlendMode.h"
#include "solarus/graphics/Drawable.h"
#include "solarus/graphics/ShaderData.h"
#include "solarus/graphics/SurfacePtr.h"
#include "solarus/graphics/VertexArrayPtr.h"
#include "solarus/lua/ExportableToLua.h"
#include <glm/mat3x3.hpp>
#include <glm/mat4x4.hpp>
#include <map>
#include <string>
#include <unordered_map>

namespace Solarus {

/**
 * \brief Represents a shader for a driver and sampler-independant uses.
 */
class SOLARUS_API Shader : public DrawProxy, public ExportableToLua {
  public:
    constexpr static const char* POSITION_NAME = "sol_vertex";
    constexpr static const char* TEXCOORD_NAME = "sol_tex_coord";
    constexpr static const char* COLOR_NAME = "sol_color";
    constexpr static const char* MVP_MATRIX_NAME = "sol_mvp_matrix";
    constexpr static const char* UV_MATRIX_NAME = "sol_uv_matrix";
    constexpr static const char* TEXTURE_NAME = "sol_texture";
    constexpr static const char* INPUT_SIZE_NAME = "sol_input_size";
    constexpr static const char* OUTPUT_SIZE_NAME = "sol_output_size";
    constexpr static const char* TIME_NAME = "sol_time";
    constexpr static const char* OPACITY_NAME = "sol_opacity";

    explicit Shader(const std::string& shader_id);
    Shader(const std::string& vertex_source,
           const std::string& fragment_source,
           double scaling_factor);

    bool is_valid() const;
    std::string get_error() const;

    const std::string& get_id() const;
    const ShaderData& get_data() const;

    std::string get_vertex_source() const;
    std::string get_fragment_source() const;

    double get_scaling_factor() const;
    void set_scaling_factor(double scaling_factor);

    virtual void set_uniform_1b(
        const std::string& uniform_name, bool value) = 0;
    virtual void set_uniform_1i(
        const std::string& uniform_name, int value) = 0;
    virtual void set_uniform_1f(
        const std::string& uniform_name, float value) = 0;
    virtual void set_uniform_2f(
        const std::string& uniform_name, float value_1, float value_2) = 0;
    virtual void set_uniform_3f(
        const std::string& uniform_name, float value_1, float value_2, float value_3) = 0;
    virtual void set_uniform_4f(
        const std::string& uniform_name, float value_1, float value_2, float value_3, float value_4) = 0;
    virtual bool set_uniform_texture(const std::string& uniform_name, const SurfacePtr& value) = 0;

    template<class T> const T& as() const {
      return *reinterpret_cast<const T*>(this);
    }

    template<class T> T& as() {
      return *reinterpret_cast<T*>(this); //TODO check if reinterpret is safe => it should
    }

    const std::string& get_lua_type_name() const override;

  protected:
    void set_valid(bool valid);
    void set_error(const std::string& error);
    void set_data(const ShaderData& data);
    static void setup_version_string();
    std::string get_sanitized_vertex_source() const;
    std::string get_sanitized_fragment_source() const;
  private:
    static std::string sanitize_shader_source(const std::string& source);
    static std::string version_string;

    const std::string shader_id;  /**< The id of the shader (filename without extension). */
    ShaderData data;              /**< The loaded shader data file. */
    std::string vertex_source;    /**< Vertex shader code. */
    std::string fragment_source;  /**< Fragment shader code. */
    bool valid;                   /**< \c true if the compilation succedeed. */
    std::string error;            /**< Error message of the last operation if any. */
};

}

#endif
