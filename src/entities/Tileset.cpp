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
#include "solarus/entities/AnimatedTilePattern.h"
#include "solarus/entities/GroundInfo.h"
#include "solarus/entities/ParallaxScrollingTilePattern.h"
#include "solarus/entities/SelfScrollingTilePattern.h"
#include "solarus/entities/SimpleTilePattern.h"
#include "solarus/entities/Tileset.h"
#include "solarus/entities/TilesetData.h"
#include "solarus/graphics/Surface.h"
#include "solarus/lua/LuaData.h"
#include "solarus/lua/LuaTools.h"
#include <lua.hpp>
#include <sstream>
#include <vector>

namespace Solarus {

/**
 * \brief Constructor.
 * \param id Id of the tileset to create.
 */
Tileset::Tileset(const std::string& id):
  id(id),
  tiles_image(nullptr),
  entities_image(nullptr),
  loaded(false) {
}

/**
 * \brief Returns the id of this tileset.
 * \return The tileset id.
 */
const std::string& Tileset::get_id() const {
  return id;
}

/**
 * \brief Adds a new tile pattern to this tileset.
 *
 * This function is called while loading the tileset.
 *
 * \param id Id of this tile pattern.
 * \param pattern_data Properties of the tile pattern to create.
 */
void Tileset::add_tile_pattern(
    const std::string& id,
    const TilePatternData& pattern_data
) {
  // Create the tile pattern.
  TilePattern* tile_pattern = nullptr;

  const std::vector<Rectangle>& frames = pattern_data.get_frames();
  const Ground ground = pattern_data.get_ground();
  const PatternScrolling scrolling = pattern_data.get_scrolling();
  const uint32_t frame_delay = pattern_data.get_frame_delay();
  bool mirror_loop = pattern_data.is_mirror_loop();

  if (frames.size() == 1) {
    // Single frame.
    const Rectangle& frame = frames[0];
    const Size& size = frame.get_size();

    // Diagonal obstacle: check that the tile is square.
    if (GroundInfo::is_ground_diagonal(ground)) {
      if (!size.is_square()) {
        Debug::error("Invalid tile pattern '"  + id + ": a tile pattern with a diagonal wall must be square");
      }
    }

    switch (scrolling) {

    case PatternScrolling::NONE:
      tile_pattern = new SimpleTilePattern(
          ground, frame.get_xy(), size
      );
      break;

    case PatternScrolling::PARALLAX:
      tile_pattern = new ParallaxScrollingTilePattern(
          ground, frame.get_xy(), size
      );
      break;

    case PatternScrolling::SELF:
      tile_pattern = new SelfScrollingTilePattern(
          ground, frame.get_xy(), size
      );
      break;
    }
  }
  else {
    // Multi-frame.
    if (scrolling == PatternScrolling::SELF) {
      Debug::error("Multi-frame is not supported for self-scrolling tiles");
      return;
    }

    bool parallax = scrolling == PatternScrolling::PARALLAX;
    tile_pattern = new AnimatedTilePattern(
        ground,
        frames,
        frame_delay,
        mirror_loop,
        parallax
    );
  }

  if (tile_pattern->is_animated()) {
    animated_tile_patterns.push_back(tile_pattern);
  }
  tile_patterns.emplace(id, std::unique_ptr<TilePattern>(tile_pattern));
}

/**
 * \brief Returns whether this tileset is loaded.
 * \return \c true if this tileset is loaded.
 */
bool Tileset::is_loaded() const {
  return loaded;
}

/**
 * \brief Loads the tileset from its file by creating all tile patterns.
 *
 * Nothing happens if the tileset is already loaded.
 */
void Tileset::load() {

  if (is_loaded()) {
    return;
  }

  std::lock_guard<std::mutex> lock(load_mutex);

  if (is_loaded()) {
    return;
  }

  // Load the tileset data file.
  std::string file_name = std::string("tilesets/") + id + ".dat";
  TilesetData data;
  bool success = data.import_from_quest_file(file_name);
  if (success) {
    // Get the imported data.
    this->background_color = data.get_background_color();
    for (const auto& kvp : data.get_patterns()) {
      add_tile_pattern(kvp.first, kvp.second);
    }
  }

  // Load the tileset images from disk but don't upload them
  // to GPU yet because we can be in a separate thread here.
  file_name = std::string("tilesets/") + id + ".tiles.png";
  tiles_image_soft = Surface::create_sdl_surface_from_file(file_name);
  if (tiles_image_soft == nullptr) {
    Debug::error(std::string("Missing tiles image for tileset '") + id + "': " + file_name);
  }
  file_name = std::string("tilesets/") + id + ".entities.png";
  entities_image_soft = Surface::create_sdl_surface_from_file(file_name);

  loaded = true;
}

/**
 * \brief Destroys the tile patterns and frees the memory used
 * by the tileset image.
 */
void Tileset::unload() {

  if (!is_loaded()) {
    return;
  }

  std::lock_guard<std::mutex> lock(load_mutex);

  if (!is_loaded()) {
    return;
  }

  tile_patterns.clear();
  tiles_image = nullptr;
  entities_image = nullptr;

  loaded = false;
}

/**
 * \brief Returns the background color of this tileset.
 * \return The background color.
 */
const Color& Tileset::get_background_color() const {
  return background_color;
}

/**
 * \brief Returns the image containing the tiles of this tileset.
 * \return The tiles image.
 */
const SurfacePtr& Tileset::get_tiles_image() const {

  if (tiles_image == nullptr) {
    if (tiles_image_soft == nullptr) {
      tiles_image = Surface::create(16, 16);
    }
    else {
      tiles_image = Surface::create(std::move(tiles_image_soft));
    }
    tiles_image_soft = nullptr;
  }

  return tiles_image;
}

/**
 * \brief Returns the image containing the tileset-dependent sprites for this tileset.
 * \return The image containing the tileset-dependent sprites for this tileset.
 * Returns \c nullptr if it does not exist.
 */
const SurfacePtr& Tileset::get_entities_image() const {

  if (entities_image == nullptr) {
    if (entities_image_soft == nullptr) {
      entities_image = Surface::create(16, 16);
    }
    else {
      entities_image = Surface::create(std::move(entities_image_soft));
    }
    entities_image_soft = nullptr;
  }
  return entities_image;
}

/**
 * \brief Returns a tile pattern from this tileset.
 * \param id Id of the tile pattern to get.
 * \return The tile pattern with this id, or nullptr if it does not exist.
 */
std::shared_ptr<TilePattern> Tileset::get_tile_pattern(const std::string& id) const {

  const auto& it = tile_patterns.find(id);
  if (it == tile_patterns.end()) {
    return nullptr;
  }
  return it->second;
}

/**
 * \brief Changes the tiles images, the entities images and the background
 * color of this tileset.
 * \param other_id Id of another tileset whose images and background color
 * will be copied into this tileset.
 */
void Tileset::set_images(const std::string& other_id) {

  // Load the new tileset to take its images.
  Tileset tmp_tileset(other_id);
  tmp_tileset.load();

  tiles_image = tmp_tileset.get_tiles_image();
  entities_image = tmp_tileset.get_entities_image();

  background_color = tmp_tileset.get_background_color();
}

/**
 * \brief Updates all patterns of this tileset.
 */
void Tileset::update() {

  for (const auto& pattern : animated_tile_patterns) {
    pattern->update();
  }
}

}

