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
#include "solarus/core/Debug.h"
#include "solarus/core/System.h"
#include "solarus/entities/AnimatedTilePattern.h"
#include "solarus/entities/ParallaxScrollingTilePattern.h"
#include "solarus/entities/Tileset.h"
#include "solarus/graphics/Surface.h"

namespace Solarus {

/**
 * \brief Creates a multi-frame tile pattern.
 * \param ground Kind of ground of the tile pattern.
 * \param frames Rectangles in the tileset image.
 * \param frame_delay Delay in milliseconds between each frame.
 * \param mirror_loop Whether to play the animation backwards when it loops.
 * \param parallax \c true to also set parallax scrolling to the tile pattern.
 */
AnimatedTilePattern::AnimatedTilePattern(
    Ground ground,
    const std::vector<Rectangle>& frames,
    uint32_t frame_delay,
    bool mirror_loop,
    bool parallax
):
  TilePattern(ground, frames[0].get_size()),
  frames(frames),
  frame_delay(frame_delay),
  mirror_loop(mirror_loop),
  parallax(parallax),
  frame_index(0),
  next_frame_date(System::now() + frame_delay) {

  Debug::check_assertion(!this->frames.empty(), "Missing frames for animated pattern");
}

/**
 * \copydoc TilePattern::update
 */
void AnimatedTilePattern::update() {

  uint32_t now = System::now();
  while (now >= next_frame_date) {
    if (!mirror_loop) {
      frame_index = (frame_index + 1) % frames.size();
    }
    else {
      frame_index = (frame_index + 1) % (2 * frames.size() - 2);
    }
    next_frame_date += frame_delay;
  }
}

/**
 * \copydoc TilePattern::draw
 */
void AnimatedTilePattern::draw(
    const SurfacePtr& dst_surface,
    const Point& dst_position,
    const Tileset& tileset,
    const Point& viewport
) const {
  const SurfacePtr& tileset_image = tileset.get_tiles_image();

  int final_frame_index = frame_index;
  int num_frames = frames.size();
  if (mirror_loop && frame_index >= num_frames) {
    final_frame_index = (2 * frames.size() - 2) - frame_index;
  }
  Debug::check_assertion(final_frame_index >= 0 && final_frame_index < num_frames, "Wrong frame index");
  const Rectangle& src = frames[final_frame_index];
  Point dst = dst_position;

  if (parallax) {
    dst += viewport / ParallaxScrollingTilePattern::ratio;
  }

  tileset_image->draw_region(src, dst_surface, dst);
}

/**
 * \brief Returns whether tiles having this tile pattern are drawn at their
 * position.
 *
 * Usually, this function returns true, and when it is the case, draw() is
 * called only for tiles that are located in the current viewport.
 *
 * However, some tile patterns may want to be drawn even when they are not
 * in the viewport, typically to make an illusion of movement like parallax
 * scrolling.
 *
 * \return true to if this tile pattern is always drawn at its coordinates
 */
bool AnimatedTilePattern::is_drawn_at_its_position() const {
  return !parallax;
}

}

