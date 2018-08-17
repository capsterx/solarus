/*
 * Copyright (C) 2018 Solarus - http://www.solarus-games.org
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// Scale2X shader adapted from bsnes
// https://gitorious.org/bsnes/xml-shaders/

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

    col  = COMPAT_TEXTURE(sol_texture, tex_coords[0]);  // central (can be E0-E3)
    colD = COMPAT_TEXTURE(sol_texture, tex_coords[1]);  // D (left)
    colF = COMPAT_TEXTURE(sol_texture, tex_coords[2]);  // F (right)
    colB = COMPAT_TEXTURE(sol_texture, tex_coords[3]);  // B (top)
    colH = COMPAT_TEXTURE(sol_texture, tex_coords[4]);  // H (bottom)

    sel = fract(tex_coords[0] * sol_texture_size.xy);       // where are we (E0-E3)?
    // E0 is default
    if (sel.y >= 0.5) {
        tmp = colB; colB = colH; colH = tmp;
    }  // E1 (or E3): swap B and H
    if (sel.x >= 0.5) {
        tmp = colF; colF = colD; colD = tmp;
    }  // E2 (or E3): swap D and F

    if (colB == colD && colB != colF && colD != colH) {  // do the Scale2x rule
        col = colD;
    }

    FragColor = col;
}
