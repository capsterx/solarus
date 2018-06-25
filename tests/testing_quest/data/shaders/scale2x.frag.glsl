#version 130

unif

orm sampler2D sol_texture;
uniform vec2 sol_input_size;
uniform vec2 sol_output_size;
vec2 sol_texture_size = sol_input_size;

varying vec2 tex_coords[5];

void main() {
    vec4 colD, colF, colB, colH, col, tmp;
    vec2 sel;

    col  = texture2D(sol_texture, tex_coords[0]);  //central (can be E0-E3)
    colD = texture2D(sol_texture, tex_coords[1]);  //D (left)
    colF = texture2D(sol_texture, tex_coords[2]);  //F (right)
    colB = texture2D(sol_texture, tex_coords[3]);  //B (top)
    colH = texture2D(sol_texture, tex_coords[4]);  //H (bottom)

    sel = fract(tex_coords[0] * sol_texture_size.xy);       //where are we (E0-E3)?
    //E0 is default
    if(sel.y >= 0.5) { tmp = colB; colB = colH; colH = tmp; }  //E1 (or E3): swap B and H
    if(sel.x >= 0.5) { tmp = colF; colF = colD; colD = tmp; }  //E2 (or E3): swap D and F

    if(colB == colD && colB != colF && colD != colH) {  //do the Scale2x rule
        col = colD;
    }

    gl_FragColor = col;
}
