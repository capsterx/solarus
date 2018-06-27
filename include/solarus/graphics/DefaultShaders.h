#ifndef SOL_DEFAULTSHADERS_H
#define SOL_DEFAULTSHADERS_H

namespace Solarus {
constexpr auto DEFAULT_VERTEX_SHADER =
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

constexpr auto DEFAULT_FRAGMENT_SHADER =
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
}

#endif // DEFAULTSHADERS_H
