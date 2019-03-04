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
#ifndef SOLARUS_TILESET_DATA_H
#define SOLARUS_TILESET_DATA_H

#include "solarus/core/Common.h"
#include "solarus/core/EnumInfo.h"
#include "solarus/core/Rectangle.h"
#include "solarus/entities/BorderSet.h"
#include "solarus/entities/Ground.h"
#include "solarus/graphics/Color.h"
#include "solarus/lua/LuaData.h"
#include <iosfwd>
#include <map>
#include <string>
#include <vector>

namespace Solarus {

/**
 * \brief Kind of scrolling applied to a tile pattern.
 */
enum class PatternScrolling {
    NONE,               /**< No scrolling. */
    SELF,               /**< Scrolling on itself. */
    PARALLAX,           /**< Parallax scrolling. */
};

template <>
struct SOLARUS_API EnumInfoTraits<PatternScrolling> {
  static const std::string pretty_name;

  static const EnumInfo<PatternScrolling>::names_type names;
};

/**
 * \brief Kind of scrolling applied to a tile pattern.
 */
enum class PatternRepeatMode {
    ALL,                /**< Repeatable in both directions. */
    HORIZONTAL,         /**< Repeatable only horizontally. */
    VERTICAL,           /**< Repeatable only vertically. */
    NONE                /**< Not repeatable. */
};

template <>
struct SOLARUS_API EnumInfoTraits<PatternRepeatMode> {
  static const std::string pretty_name;

  static const EnumInfo<PatternRepeatMode>::names_type names;
};

/**
 * \brief Stores the properties of a tile pattern.
 */
class SOLARUS_API TilePatternData {

  public:

    constexpr static int default_frame_delay = 250;

    TilePatternData();
    explicit TilePatternData(const Rectangle& frame);

    Ground get_ground() const;
    void set_ground(Ground ground);

    int get_default_layer() const;
    void set_default_layer(int default_layer);

    PatternScrolling get_scrolling() const;
    void set_scrolling(PatternScrolling scrolling);

    PatternRepeatMode get_repeat_mode() const;
    void set_repeat_mode(PatternRepeatMode repeat_mode);

    const std::vector<Rectangle>& get_frames() const;
    void set_frames(const std::vector<Rectangle>& frames);
    bool is_multi_frame() const;
    int get_num_frames() const;
    Rectangle get_frame() const;
    void set_frame(const Rectangle& frame);

    int get_frame_delay() const;
    void set_frame_delay(int frame_delay);

    bool is_mirror_loop() const;
    void set_mirror_loop(bool mirror_loop);

  private:

    Ground ground;                     /**< Terrain of this pattern. */
    int default_layer;                 /**< Initial layer when creating a tile. */
    PatternScrolling scrolling;        /**< Kind of scrolling if any. */
    PatternRepeatMode repeat_mode;     /**< How this patterns intends to be repeated. */
    std::vector<Rectangle> frames;     /**< Coordinates of the pattern's frame(s). */
    int frame_delay;                   /**< Delay between each frame in milliseconds. */
    bool mirror_loop;                  /**< Whether to play the animation backwards when looping. */
};

/**
 * \brief Stores the content of a tileset data file.
 */
class SOLARUS_API TilesetData : public LuaData {

  public:

    TilesetData();

    void clear();

    Color get_background_color() const;
    void set_background_color(const Color& background_color);

    int get_num_patterns() const;
    const std::map<std::string, TilePatternData>& get_patterns() const;
    bool pattern_exists(const std::string& pattern_id) const;
    const TilePatternData* get_pattern(const std::string& pattern_id) const;
    TilePatternData* get_pattern(const std::string& pattern_id);
    bool add_pattern(
        const std::string& pattern_id, const TilePatternData& pattern);
    bool remove_pattern(const std::string& pattern_id);
    bool set_pattern_id(
        const std::string& old_pattern_id, const std::string& new_pattern_id);

    int get_num_border_sets() const;
    const std::map<std::string, BorderSet>& get_border_sets() const;
    bool border_set_exists(const std::string& border_set_id) const;
    const BorderSet& get_border_set(const std::string& border_set_id) const;
    BorderSet& get_border_set(const std::string& border_set_id);
    bool add_border_set(
        const std::string& border_set_id, const BorderSet& border_set);
    bool remove_border_set(const std::string& border_set_id);
    bool set_border_set_id(
        const std::string& old_border_set_id, const std::string& new_border_set_id);

    virtual bool import_from_lua(lua_State* l) override;
    virtual bool export_to_lua(std::ostream& out) const override;

  private:

    Color background_color;       /**< Background color of the tileset. */
    std::map<std::string, TilePatternData>
        patterns;                 /**< The tile patterns indexed by their id. */
    std::map<std::string, BorderSet>
        border_sets;              /**< The border sets indexes by their id. */

};

}

#endif

