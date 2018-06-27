#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_ATTRIBUTE in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying
#define COMPAT_ATTRIBUTE attribute
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
precision mediump float;
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

COMPAT_ATTRIBUTE vec2 sol_vertex;
COMPAT_ATTRIBUTE vec2 sol_tex_coord;

uniform vec2 sol_input_size;
uniform vec2 sol_output_size;
uniform mat4 sol_mvp_matrix;
uniform mat3 sol_uv_matrix;
vec2 sol_texture_size = sol_input_size;

COMPAT_VARYING vec2 tex_coords[5];

void main() {
    vec2 offsetx;
    vec2 offsety;

    gl_Position = sol_mvp_matrix*vec4(sol_vertex,0,1);

    offsetx.x = 1.0 / sol_texture_size.x;
    offsetx.y = 0.0;
    offsety.y = 1.0 / sol_texture_size.y;
    offsety.x = 0.0;

    tex_coords[0] = vec2(sol_uv_matrix*vec3(sol_tex_coord,1));         //center
    tex_coords[1] = tex_coords[0] - offsetx;  //left
    tex_coords[2] = tex_coords[0] + offsetx;  //right
    tex_coords[3] = tex_coords[0] - offsety;  //top
    tex_coords[4] = tex_coords[0] + offsety;  //bottom
}
