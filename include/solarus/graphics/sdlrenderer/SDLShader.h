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
#pragma once
#include "solarus/core/Common.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/BlendMode.h"
#include "solarus/graphics/Drawable.h"
#include "solarus/graphics/ShaderData.h"
#include "solarus/graphics/SurfacePtr.h"
#include "solarus/graphics/VertexArrayPtr.h"
#include "solarus/graphics/Shader.h"
#include "solarus/lua/ExportableToLua.h"
#include <glm/mat3x3.hpp>
#include <glm/mat4x4.hpp>
#include <map>
#include <string>
#include <unordered_map>

#include "../SolarusGl.h"

namespace Solarus {

/**
 * \brief Represents a shader for a driver and sampler-independant uses.
 */
class SOLARUS_API SDLShader : public Shader {
  public:
    SDLShader();
    explicit SDLShader(const std::string& shader_id);
    SDLShader(const std::string& vertex_source,
           const std::string& fragment_source,
           double scaling_factor);
    ~SDLShader() override;

    static bool initialize();
    static void quit();

    void set_uniform_1b(
        const std::string& uniform_name, bool value) override;
    void set_uniform_1i(
        const std::string& uniform_name, int value) override;
     void set_uniform_1f(
        const std::string& uniform_name, float value) override;
     void set_uniform_2f(
        const std::string& uniform_name, float value_1, float value_2) override;
     void set_uniform_3f(
        const std::string& uniform_name, float value_1, float value_2, float value_3) override;
     void set_uniform_4f(
        const std::string& uniform_name, float value_1, float value_2, float value_3, float value_4) override;
     bool set_uniform_texture(const std::string& uniform_name, const SurfacePtr& value) override;

    void render(const Surface& surface, const Rectangle& region, const Size& dst_size, const Point& dst_position = Point(), bool flip_y = false);
    void draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& infos) const override;

    /**
     * \brief render the given vertex array with this shader, passing the texture and matrices as uniforms
     * \param array a vertex array
     * \param texture a valid surface
     * \param mvp_matrix model view projection matrix
     * \param uv_matrix uv_matrix
     */
     void render(const VertexArray& array,
                        const Surface &texture,
                        const glm::mat4& mvp_matrix = glm::mat4(1.f),
                        const glm::mat3& uv_matrix = glm::mat3(1.f));

  private:
    void compile();
    static std::string sanitize_shader_source(const std::string source);


    static VertexArray screen_quad; /**< The quad used to draw surfaces with shaders */

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
