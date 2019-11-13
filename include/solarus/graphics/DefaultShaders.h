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
#ifndef SOLARUS_DEFAULTSHADERS_H
#define SOLARUS_DEFAULTSHADERS_H

#include <string>

namespace Solarus {

namespace DefaultShaders {

/**
 * \brief Gets the default vertex shader compatibility source header.
 * This should be included at the beginning of every vertex shader program
 * source to ensure compatibility across different GLSL versions.
 */
inline const std::string& get_default_vertex_compat_header() {

  static const std::string source =
R"(
#if __VERSION__ >= 130
#define COMPAT_VARYING out
#define COMPAT_ATTRIBUTE in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying
#define COMPAT_ATTRIBUTE attribute
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif
)";
  return source;
}

/**
 * \brief Gets the Solarus default vertex shader program source.
 */
inline const std::string& get_default_vertex_source() {

  static const std::string source = get_default_vertex_compat_header() +
R"(
uniform mat4 sol_mvp_matrix;
uniform mat3 sol_uv_matrix;
COMPAT_ATTRIBUTE vec2 sol_vertex;
COMPAT_ATTRIBUTE vec2 sol_tex_coord;
COMPAT_ATTRIBUTE vec4 sol_color;
COMPAT_VARYING vec2 sol_vtex_coord;
COMPAT_VARYING vec4 sol_vcolor;

void main() {
    gl_Position = sol_mvp_matrix * vec4(sol_vertex, 0.0, 1.0);
    sol_vcolor = sol_color;
    sol_vtex_coord = (sol_uv_matrix * vec3(sol_tex_coord, 1.0)).xy;
}
)";
  return source;
}

/**
 * \brief Gets the default fragment shader compatibility source header.
 * This should be included at the beginning of every fragment shader program
 * source to ensure compatibility across different GLSL versions.
 */
inline const std::string& get_default_fragment_compat_header() {

  static const std::string source =
R"(
#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
out COMPAT_PRECISION vec4 FragColor;
#else
#define COMPAT_VARYING varying
#define FragColor gl_FragColor
#define COMPAT_TEXTURE texture2D
#endif
)";
  return source;
}

/**
 * \brief Gets the Solarus default fragment shader program source.
 */
inline const std::string& get_default_fragment_source() {

static const std::string source = get_default_fragment_compat_header() +
R"(
uniform sampler2D sol_texture;
uniform bool sol_vcolor_only;
uniform bool sol_alpha_mult;
COMPAT_VARYING vec2 sol_vtex_coord;
COMPAT_VARYING vec4 sol_vcolor;

void main() {
    if (!sol_vcolor_only) {
        vec4 tex_color = COMPAT_TEXTURE(sol_texture, sol_vtex_coord);
        FragColor = tex_color * sol_vcolor;
        if (sol_alpha_mult) {
            FragColor.rgb *= sol_vcolor.a; //Premultiply by opacity too
        }
    } else {
        FragColor = sol_vcolor;
    }
}
)";
  return source;
}

}  // namespace DefaultShaders

}  // namespace Solarus

#endif
