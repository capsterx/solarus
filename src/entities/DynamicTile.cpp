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
#include "solarus/core/Debug.h"
#include "solarus/core/Game.h"
#include "solarus/core/Map.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/ResourceProvider.h"
#include "solarus/entities/Camera.h"
#include "solarus/entities/DynamicTile.h"
#include "solarus/entities/Hero.h"
#include "solarus/entities/Tileset.h"
#include "solarus/entities/TilePattern.h"

namespace Solarus {

/**
 * \brief Creates a new dynamic tile on the map.
 * \param name A name to identify this entity.
 * \param layer Layer of the tile.
 * \param xy Coordinates of the tile on the map.
 * \param size Size of the tile (the pattern can be repeated).
 * \param tile_pattern_id Id of the tile pattern in the tileset.
 * \param tile_pattern The tile pattern, or nullptr if it does not exist in the tileset.
 * \param tileset The tileset to use (nullptr means the one of the map).
 */
DynamicTile::DynamicTile(
    const std::string& name,
    int layer,
    const Point& xy,
    const Size& size,
    const std::string& tile_pattern_id,
    const std::shared_ptr<TilePattern>& tile_pattern,
    const Tileset* tileset
) :
  Entity(name, 0, layer, xy, size),
  tile_pattern_id(tile_pattern_id),
  tile_pattern(tile_pattern),
  tileset(tileset) {

  set_tiled(true);
}

/**
 * \brief Returns the type of entity.
 * \return the type of entity
 */
EntityType DynamicTile::get_type() const {
  return ThisType;
}

/**
 * \brief Returns the id of the pattern of this dynamic tile.
 * \return The tile pattern id.
 */
const std::string& DynamicTile::get_tile_pattern_id() const {
  return tile_pattern_id;
}

/**
 * \brief When is_ground_modifier() is \c true, returns the ground defined
 * by this entity.
 * \return The ground defined by this entity.
 */
Ground DynamicTile::get_modified_ground() const {

  if (tile_pattern == nullptr) {
    return Ground::EMPTY;
  }
  return tile_pattern->get_ground();
}

/**
 * \brief Returns the tileset of this dynamic tile.
 * \return The tileset used (\c nullptr if map's tileset is used).
 */
const Tileset* DynamicTile::get_tileset() const {
  return this->tileset;
}

/**
 * \brief Set the tileset for this dynamic tile.
 * \param tileset The tileset (\c nullptr to use the map's tileset).
 */
void DynamicTile::set_tileset(const Tileset* tileset) {
    this->tileset = tileset;
}

/**
 * \brief Set the tileset for this dynamic tile by tileset id.
 * \param tileset_id Id of the tileset to use.
 */
void DynamicTile::set_tileset(const std::string& tileset_id) {
    tileset = &get_game().get_resource_provider().get_tileset(tileset_id);
}

/**
 * \copydoc Entity::is_drawn_at_its_position()
 */
bool DynamicTile::is_drawn_at_its_position() const {

  if (tile_pattern == nullptr) {
    return true;
  }
  return tile_pattern->is_drawn_at_its_position();
}

/**
 * \copydoc Entity::built_in_draw
 */
void DynamicTile::built_in_draw(Camera& camera) {

  if (tile_pattern != nullptr) {
    const Rectangle& camera_position = camera.get_bounding_box();

    Rectangle dst_position(get_top_left_x() - camera_position.get_x(),
        get_top_left_y() - camera_position.get_y(),
        get_width(), get_height());

    const Tileset* tileset = this->tileset != nullptr ? this->tileset : &get_map().get_tileset();
    tile_pattern->fill_surface(
        camera.get_surface(),
        dst_position,
        *tileset,
        camera_position.get_xy()
    );
  }

  Entity::built_in_draw(camera);
}

/**
 * \copydoc Entity::notify_tileset_changed
 */
void DynamicTile::notify_tileset_changed() {

  // The tileset of the map has changed.
  // Update the pattern if we use that tileset.
  if (tileset == nullptr) {
    tile_pattern = get_map().get_tileset().get_tile_pattern(tile_pattern_id);
  }
}

}
