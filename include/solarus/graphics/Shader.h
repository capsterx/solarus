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
#ifndef SOLARUS_SHADER_H
#define SOLARUS_SHADER_H

#include "solarus/core/Common.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/ShaderData.h"
#include "solarus/graphics/SurfacePtr.h"
#include "solarus/graphics/VertexArrayPtr.h"
#include "solarus/graphics/BlendMode.h"
#include <glm/mat4x4.hpp>
#include <glm/mat3x3.hpp>
#include "solarus/lua/ExportableToLua.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"

#include "solarus/graphics/Drawable.h"

#include <string>
#include <unordered_map>

#ifdef SOLARUS_HAVE_OPENGL
#  include <SDL_opengl.h>
#else
#  include <SDL_opengles2.h>
#endif

namespace Solarus {

/**
 * \brief Represents a shader for a driver and sampler-independant uses.
 */
class Shader : public DrawProxy, public ExportableToLua {
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
    ~Shader();

    bool is_valid() const;
    std::string get_error() const;

    const std::string& get_id() const;
    const ShaderData& get_data() const;

    std::string get_vertex_source() const;
    std::string get_fragment_source() const;

    static std::string default_vertex_source();
    static std::string default_fragment_source();

    double get_scaling_factor() const;
    void set_scaling_factor(double scaling_factor);

    static bool initialize();
    static void quit();

    void set_uniform_1b(
        const std::string& uniform_name, bool value);
    void set_uniform_1i(
        const std::string& uniform_name, int value);
     void set_uniform_1f(
        const std::string& uniform_name, float value);
     void set_uniform_2f(
        const std::string& uniform_name, float value_1, float value_2);
     void set_uniform_3f(
        const std::string& uniform_name, float value_1, float value_2, float value_3);
     void set_uniform_4f(
        const std::string& uniform_name, float value_1, float value_2, float value_3, float value_4);
     bool set_uniform_texture(const std::string& uniform_name, const SurfacePtr& value);

    void render(const Surface& surface, const Rectangle& region, const Size& dst_size, const Point& dst_position = Point(), bool flip_y = false);
    void draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& infos) const override;

    /**
     * @brief render the given vertex array with this shader, passing the texture and matrices as uniforms
     * @param array a vertex array
     * @param texture a valid surface
     * @param mvp_matrix model view projection matrix
     * @param uv_matrix uv_matrix
     */
     void render(const VertexArray& array,
                        const Surface &texture,
                        const glm::mat4& mvp_matrix = glm::mat4(),
                        const glm::mat3& uv_matrix = glm::mat3());

    const std::string& get_lua_type_name() const override;

  protected:
    void set_valid(bool valid);
    void set_error(const std::string& error);
    void set_data(const ShaderData& data);
    void load();
    static VertexArray screen_quad; /**< The quad used to draw surfaces with shaders */

  private:
    void check_gl_error();
    void enable_attribute(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* pointer);
    void restore_attribute_states();

    struct TextureUniform{
      SurfacePtr surface;
      GLuint unit;
    };

    GLuint create_shader(unsigned int type, const char* source);
    static void set_rendering_settings();
    GLint get_uniform_location(const std::string& uniform_name) const;

    static inline void compute_matrices(
        const Size& surface_size,
        const Rectangle& region,
        const Size& dst_size,
        const Point& dst_position,
        bool flip_y,
        glm::mat4& viewport,
        glm::mat4& dst,
        glm::mat4& scale,
        glm::mat3& uvm);

    const std::string shader_id;  /**< The id of the shader (filename without extension). */
    ShaderData data;              /**< The loaded shader data file. */
    bool valid;                   /**< \c true if the compilation succedeed. */
    std::string error;            /**< Error message of the last operation if any. */

    GLuint program;                         /**< The program which bind the vertex and fragment shader. */
    GLuint vertex_shader;                   /**< The vertex shader. */
    GLuint fragment_shader;                 /**< The fragment shader. */
    GLint position_location;                     /**< The location of the position attrib. */
    GLint tex_coord_location;                    /**< The location of the tex_coord attrib. */
    GLint color_location;                        /**< The location of the color attrib. */
    mutable std::map<std::string, GLint>
        uniform_locations;                       /**< Cache of uniform locations. */
    mutable std::map<std::string, TextureUniform>
        uniform_textures;                        /**< Uniform texture value of surfaces. */
    std::unordered_map<GLuint, GLint> attribute_states;    /**< Previous attrib states. */
    GLuint current_texture_unit = 0;
};

}

#endif
