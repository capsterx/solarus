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
uniform vec2 sol_input_size;
uniform vec2 sol_output_size;
vec2 sol_texture_size = sol_input_size;

COMPAT_VARYING vec2 tex_coords[5];

void main() {
    vec4 colD, colF, colB, colH, col, tmp;
    vec2 sel;

    col  = COMPAT_TEXTURE(sol_texture, tex_coords[0]);  //central (can be E0-E3)
    colD = COMPAT_TEXTURE(sol_texture, tex_coords[1]);  //D (left)
    colF = COMPAT_TEXTURE(sol_texture, tex_coords[2]);  //F (right)
    colB = COMPAT_TEXTURE(sol_texture, tex_coords[3]);  //B (top)
    colH = COMPAT_TEXTURE(sol_texture, tex_coords[4]);  //H (bottom)

    sel = fract(tex_coords[0] * sol_texture_size.xy);       //where are we (E0-E3)?
    //E0 is default
    if(sel.y >= 0.5) { tmp = colB; colB = colH; colH = tmp; }  //E1 (or E3): swap B and H
    if(sel.x >= 0.5) { tmp = colF; colF = colD; colD = tmp; }  //E2 (or E3): swap D and F

    if(colB == colD && colB != colF && colD != colH) {  //do the Scale2x rule
        col = colD;
    }

    FragColor = col;
}
