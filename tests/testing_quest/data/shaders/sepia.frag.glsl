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
    vec3 texel = COMPAT_TEXTURE(sol_texture, sol_vtex_coord).rgb;
    FragColor = vec4(texel.x,texel.y,texel.z, 1.0);

    FragColor.r = dot(texel, vec3(.393, .769, .189));
    FragColor.g = dot(texel, vec3(.349, .686, .168));
    FragColor.b = dot(texel, vec3(.272, .534, .131));
}
