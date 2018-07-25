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
#ifndef SOLARUS_ANIMATED_TILE_PATTERN_H
#define SOLARUS_ANIMATED_TILE_PATTERN_H

#include "solarus/core/Common.h"
#include "solarus/core/Rectangle.h"
#include "solarus/entities/TilePattern.h"
#include <cstdint>
#include <vector>

namespace Solarus {

/**
 * \brief Multi-frame tile pattern.
 *
 * Unlike simple tile patterns that always display the same image,
 * an animated tile pattern displays successive frames.
 */
class AnimatedTilePattern: public TilePattern {

  public:

    AnimatedTilePattern(
        Ground ground,
        const std::vector<Rectangle>& frames,
        uint32_t frame_delay,
        bool mirror_loop,
        bool parallax
    );

    void update() override;

    void draw(
        const SurfacePtr& dst_surface,
        const Point& dst_position,
        const Tileset& tileset,
        const Point& viewport
    ) const override;
    bool is_drawn_at_its_position() const override;

  private:

    std::vector<Rectangle> frames;    /**< List of rectangles representing the animation frames
                                       * of this tile pattern in the tileset image.
                                       * The frames should have the same width and height. */
    uint32_t frame_delay;             /**< Delay between frames in milliseconds. */
    bool mirror_loop;                 /**< Whether to play the animation backwards when it loops. */
    bool parallax;                    /**< Indicates that the tile pattern also makes parallax scrolling */

    int frame_index;                  /**< Index of the current frame.
                                       * - if no mirror loop: between 0 and frames.size() - 1
                                       * - if mirror loop: between 0 and 2 * frames.size() - 3 */
    uint32_t next_frame_date;         /**< Date of the next frame change. */


};

}

#endif

