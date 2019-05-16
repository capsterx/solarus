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
#include <vector>

#include "../SolarusGl.h"

namespace Solarus {

/**
 * \brief Represents a shader for a driver and sampler-independant uses.
 */
class SOLARUS_API GlShader : public Shader {
  friend class GlRenderer;
  public:
    explicit GlShader(const std::string& shader_id);
    GlShader(const std::string& vertex_source,
           const std::string& fragment_source,
           double scaling_factor);
    ~GlShader() override;

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

    void draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& infos) const override;

    void bind();
    void unbind();

    struct Uniform {
      enum class Type {
        U1B,
        U1I,
        U1F,
        U2F,
        U3F,
        U4F
      };
      std::string name;
      Type t;
      Uniform(const std::string& name, const glm::vec2& v) :
        name(name),
        t(Type::U2F),
        ff(v)
      {}
      Uniform(const std::string& name, const glm::vec3& v) :
        name(name),
        t(Type::U3F),
        fff(v)
      {}
      Uniform(const std::string& name, const glm::vec4& v) :
        name(name),
        t(Type::U4F),
        ffff(v)
      {}
      Uniform(const std::string& name, float f) :
        name(name),
        t(Type::U1F),
        f(f)
      {}
      Uniform(const std::string& name, int i) :
        name(name),
        t(Type::U1I),
        i(i)
      {}
      Uniform(const std::string& name, bool b) :
        name(name),
        t(Type::U1B),
        b(b)
      {}
      union{ //TODO C++17 variant instead, see you in 2023!
        bool b;
        int i;
        float f;
        glm::vec2 ff;
        glm::vec3 fff;
        glm::vec4 ffff;
      };
    };

  private:
    void compile();


    void set_uniform(const Uniform& uniform);
    void upload_uniform(const Uniform& uniform);

    struct TextureUniform{
      SurfacePtr surface;
      GLuint unit;
    };

    GLuint create_shader(unsigned int type, const char* source);
    GLint get_uniform_location(const std::string& uniform_name) const;

    bool bound = false;
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
    std::vector<Uniform> pending_uniforms;
    GLuint current_texture_unit = 0;
};

}
