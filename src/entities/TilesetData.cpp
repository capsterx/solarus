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
#include "solarus/entities/GroundInfo.h"
#include "solarus/entities/TilesetData.h"
#include "solarus/lua/LuaTools.h"
#include <ostream>
#include <sstream>

namespace Solarus {

const std::string EnumInfoTraits<PatternScrolling>::pretty_name = "tile scrolling";

const EnumInfo<PatternScrolling>::names_type EnumInfoTraits<PatternScrolling>::names = {
    { PatternScrolling::NONE, "" },
    { PatternScrolling::PARALLAX, "parallax" },
    { PatternScrolling::SELF, "self" },
};

const std::string EnumInfoTraits<PatternRepeatMode>::pretty_name = "tile pattern repeat mode";

const EnumInfo<PatternRepeatMode>::names_type EnumInfoTraits<PatternRepeatMode>::names = {
    { PatternRepeatMode::ALL, "all" },
    { PatternRepeatMode::HORIZONTAL, "horizontal" },
    { PatternRepeatMode::VERTICAL, "vertical" },
    { PatternRepeatMode::NONE, "none" },
};

/**
 * \brief Creates a default single-frame tile pattern.
 */
TilePatternData::TilePatternData() :
    TilePatternData(Rectangle(0, 0, 16, 16)) {
}

/**
 * \brief Creates a single-frame tile pattern.
 * \param frame Coordinates of the single frame to make.
 */
TilePatternData::TilePatternData(const Rectangle& frame) :
    ground(Ground::TRAVERSABLE),
    default_layer(0),
    scrolling(PatternScrolling::NONE),
    repeat_mode(PatternRepeatMode::ALL),
    frames(),
    frame_delay(default_frame_delay),
    mirror_loop(false) {

  set_frame(frame);
}

/**
 * \brief Returns the kind of ground of this pattern.
 * \return The ground.
 */
Ground TilePatternData::get_ground() const {
  return ground;
}

/**
 * \brief Sets the kind of ground of this pattern.
 * \param ground The ground.
 */
void TilePatternData::set_ground(Ground ground) {
  this->ground = ground;
}

/**
 * \brief Returns the initial layer when creating a tile with this pattern.
 * \return The default layer.
 */
int TilePatternData::get_default_layer() const {
  return default_layer;
}

/**
 * \brief Sets the initial layer when creating a tile with this pattern.
 * \param default_layer The default layer.
 */
void TilePatternData::set_default_layer(int default_layer) {
  this->default_layer = default_layer;
}

/**
 * \brief Returns the kind of scrolling of this pattern.
 * \return The scrolling property.
 */
PatternScrolling TilePatternData::get_scrolling() const {
  return scrolling;
}

/**
 * \brief Sets the kind of scrolling of this pattern.
 * \param scrolling The scrolling property.
 */
void TilePatternData::set_scrolling(PatternScrolling scrolling) {
  this->scrolling = scrolling;
}

/**
 * \brief Returns how this pattern is intended to be repeated.
 */
PatternRepeatMode TilePatternData::get_repeat_mode() const {
  return repeat_mode;
}

/**
 * \brief Sets how this pattern is intended to be repeated.
 */
void TilePatternData::set_repeat_mode(PatternRepeatMode repeat_mode) {
  this->repeat_mode = repeat_mode;
}

/**
 * \brief Returns the coordinates of each frame of this pattern in the tileset
 * image file.
 * \return The coordinates of the frame(s) of this pattern.
 */
const std::vector<Rectangle>& TilePatternData::get_frames() const {
  return frames;
}

/**
 * \brief Sets the coordinates of each frame of this pattern in the tileset
 * image file.
 * \param frames The coordinates of the frame(s) of this pattern.
 */
void TilePatternData::set_frames(const std::vector<Rectangle>& frames) {

  Debug::check_assertion(!frames.empty(), "No frames");
  this->frames = frames;
}

/**
 * \brief Returns whether this is a multi-frame pattern.
 * \return \c true if the pattern has more than one frame.
 */
bool TilePatternData::is_multi_frame() const {
  return get_num_frames() > 1;
}

/**
 * \brief Returns the number of frames of this pattern.
 * \return The number of frames.
 */
int TilePatternData::get_num_frames() const {
  return static_cast<int>(frames.size());
}

/**
 * \brief Returns the coordinates of this pattern in the tileset image file.
 *
 * If the pattern is multi-frame, returns the first frame.
 *
 * \return The coordinates of the first frame of this pattern.
 */
Rectangle TilePatternData::get_frame() const {

  Debug::check_assertion(!frames.empty(), "No pattern frames");
  return frames[0];
}

/**
 * \brief Sets the coordinates of this pattern in the tileset image file.
 *
 * The pattern will have a single frame.
 *
 * \param frame The coordinates of the single frame of this pattern.
 */
void TilePatternData::set_frame(const Rectangle& frame) {
  this->frames.clear();
  this->frames.push_back(frame);
}

/**
 * \brief Returns the delay between frames.
 *
 * This only has an effect for multi-frame patterns.
 *
 * \return The frame delay in milliseconds.
 */
int TilePatternData::get_frame_delay() const {
  return frame_delay;
}

/**
 * \brief Sets the delay between frames.
 *
 * This only has an effect for multi-frame patterns.
 *
 * \param frame_delay The frame delay in milliseconds.
 */
void TilePatternData::set_frame_delay(int frame_delay) {

  Debug::check_assertion(frame_delay > 0, "Invalid frame delay");
  this->frame_delay = frame_delay;
}

/**
 * \brief Returns whether the animation plays backwards when looping.
 * \return \c true if the animation should play backwards.
 */
bool TilePatternData::is_mirror_loop() const {
  return mirror_loop;
}

/**
 * \brief Sets whether the animation should play backwards when looping.
 * \param mirror_loop \c true to play the animation backwards.
 */
void TilePatternData::set_mirror_loop(bool mirror_loop) {
  this->mirror_loop = mirror_loop;
}

/**
 * \brief Creates an empty tileset.
 */
TilesetData::TilesetData() :
    background_color(Color::white),
    patterns() {

}

/**
 * \brief Removes all content of this tileset.
 */
void TilesetData::clear() {
  background_color = Color::white;
  patterns.clear();
  border_sets.clear();
}

/**
 * \brief Returns the tileset's background color.
 * \return The background color.
 */
Color TilesetData::get_background_color() const {
  return background_color;
}

/**
 * \brief Sets the tileset's background color.
 * \param background_color The background color.
 */
void TilesetData::set_background_color(const Color& background_color) {
  this->background_color = background_color;
}

/**
 * \brief Returns the number of patterns in this tileset.
 * \return The number of patterns.
 */
int TilesetData::get_num_patterns() const {
  return patterns.size();
}

/**
 * \brief Returns all tile patterns of this tileset.
 * \return The tile patterns indexed by their id.
 */
const std::map<std::string, TilePatternData>& TilesetData::get_patterns() const {
  return patterns;
}

/**
 * \brief Returns whether there exists a tile pattern with the specified id.
 * \param pattern_id The id to test.
 * \return \c true if a tile pattern exists with this id in the tileset.
 */
bool TilesetData::pattern_exists(const std::string& pattern_id) const {
  return patterns.find(pattern_id) != patterns.end();
}

/**
 * \brief Returns the pattern with the specified id.
 * \param pattern_id A tile pattern id.
 * \return The pattern with this id, or nullptr if it does not exist.
 * The object remains valid until tile patterns are added or removed.
 */
const TilePatternData* TilesetData::get_pattern(const std::string& pattern_id) const {

  const auto& it = patterns.find(pattern_id);
  if (it == patterns.end()) {
    return nullptr;
  }

  return &it->second;
}

/**
 * \overload
 *
 * Non-const version.
 */
TilePatternData* TilesetData::get_pattern(const std::string& pattern_id) {

  const auto& it = patterns.find(pattern_id);
  if (it == patterns.end()) {
    return nullptr;
  }

  return &it->second;
}

/**
 * \brief Adds a pattern to the tileset.
 * \param pattern_id Id of the new pattern.
 * \param pattern The pattern to add.
 * \return \c true in case of success.
 */
bool TilesetData::add_pattern(
    const std::string& pattern_id, const TilePatternData& pattern) {

  const auto& result = patterns.emplace(pattern_id, pattern);
  if (!result.second) {
    // Insertion failed: the id already exists.
    return false;
  }

  return true;
}

/**
 * \brief Removes a pattern from the tileset.
 * \param pattern_id Id of the pattern to remove.
 * \return \c true in case of success.
 */
bool TilesetData::remove_pattern(const std::string& pattern_id) {

  return patterns.erase(pattern_id) > 0;
}

/**
 * \brief Changes the id of a pattern in the tileset.
 * \param old_pattern_id Old id of the pattern.
 * \param new_pattern_id New id to set.
 * \return \c true in case of success.
 * In case of failure, the old pattern is unchanged.
 */
bool TilesetData::set_pattern_id(
    const std::string& old_pattern_id, const std::string& new_pattern_id) {

  if (!pattern_exists(old_pattern_id)) {
    // No pattern was found with the old id.
    return false;
  }

  if (pattern_exists(new_pattern_id)) {
    // The new id is already used.
    return false;
  }

  TilePatternData pattern = *get_pattern(old_pattern_id);
  remove_pattern(old_pattern_id);
  add_pattern(new_pattern_id, pattern);

  return true;
}

/**
 * \brief Returns the number of border sets in this tileset.
 * \return The number of border sets.
 */
int TilesetData::get_num_border_sets() const {
  return border_sets.size();
}

/**
 * \brief Returns all border sets of this tileset.
 * \return The border sets indexed by their id.
 */
const std::map<std::string, BorderSet>& TilesetData::get_border_sets() const {
  return border_sets;
}

/**
 * \brief Returns whether there exists a border set with the specified id.
 * \param border_set_id The id to test.
 * \return \c true if a border set exists with this id in the tileset.
 */
bool TilesetData::border_set_exists(const std::string& border_set_id) const {
  return border_sets.find(border_set_id) != border_sets.end();
}

/**
 * \brief Returns the border set with the specified id.
 * \param border_set_id A border set id. It must exist.
 * \return The border_set with this id.
 * The object remains valid until border sets are added or removed.
 */
const BorderSet& TilesetData::get_border_set(const std::string& border_set_id) const {

  const auto& it = border_sets.find(border_set_id);
  Debug::check_assertion(it != border_sets.end(),
    std::string("No such border set: '") + border_set_id + "'");

  return it->second;
}

/**
 * \brief Returns the border set with the specified id.
 *
 * Non-const version.
 *
 * \param border_set_id A border set id. It must exist.
 * \return The border_set with this id.
 * The object remains valid until border sets are added or removed.
 */
BorderSet& TilesetData::get_border_set(const std::string& border_set_id) {

  const auto& it = border_sets.find(border_set_id);
  Debug::check_assertion(it != border_sets.end(),
    std::string("No such border set: '") + border_set_id + "'");

  return it->second;
}

/**
 * \brief Adds a border set to the tileset.
 * \param border_set_id Id of the new border set.
 * \param border_set The border set to add.
 * \return \c true in case of success.
 */
bool TilesetData::add_border_set(
    const std::string& border_set_id, const BorderSet& border_set) {

  const auto& result = border_sets.emplace(border_set_id, border_set);
  if (!result.second) {
    // Insertion failed: the id already exists.
    return false;
  }

  return true;
}

/**
 * \brief Removes a border set from the tileset.
 * \param border_set_id Id of the border set to remove.
 * \return \c true in case of success.
 */
bool TilesetData::remove_border_set(const std::string& border_set_id) {

  return border_sets.erase(border_set_id) > 0;
}

/**
 * \brief Changes the id of a border set in the tileset.
 * \param old_border_set_id Old id of the border set.
 * \param new_border_set_id New id to set.
 * \return \c true in case of success.
 * In case of failure, the old border set is unchanged.
 */
bool TilesetData::set_border_set_id(
    const std::string& old_border_set_id, const std::string& new_border_set_id) {

  if (!border_set_exists(old_border_set_id)) {
    // No border set was found with the old id.
    return false;
  }

  if (border_set_exists(new_border_set_id)) {
    // The new id is already used.
    return false;
  }

  BorderSet border_set = get_border_set(old_border_set_id);
  remove_border_set(old_border_set_id);
  add_border_set(new_border_set_id, border_set);

  return true;
}

namespace {

/**
 * \brief Function called by Lua to set the background color of the tileset.
 *
 * - Argument 1 (table): background color (must be an array of 3 integers).
 *
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int l_background_color(lua_State* l) {

  return LuaTools::exception_boundary_handle(l, [&] {
    lua_getfield(l, LUA_REGISTRYINDEX, "tileset");
    TilesetData& tileset = *static_cast<TilesetData*>(lua_touserdata(l, -1));
    lua_pop(l, 1);

    const Color& background_color = LuaTools::check_color(l, 1);

    tileset.set_background_color(background_color);

    return 0;
  });
}

/**
 * \brief Function called by Lua to add a tile pattern to the tileset.
 *
 * - Argument 1 (table): A table describing the tile pattern to create.
 *
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int l_tile_pattern(lua_State* l) {

  return LuaTools::exception_boundary_handle(l, [&] {
    lua_getfield(l, LUA_REGISTRYINDEX, "tileset");
    TilesetData& tileset_data = *static_cast<TilesetData*>(lua_touserdata(l, -1));
    lua_pop(l, 1);

    TilePatternData pattern_data;

    const std::string& id = LuaTools::check_string_field(l, 1, "id");

    const Ground ground = LuaTools::check_enum_field<Ground>(
        l, 1, "ground"
    );
    pattern_data.set_ground(ground);

    const int default_layer = LuaTools::check_int_field(
        l, 1, "default_layer"
    );
    pattern_data.set_default_layer(default_layer);

    const PatternScrolling scrolling = LuaTools::opt_enum_field<PatternScrolling>(
        l, 1, "scrolling", PatternScrolling::NONE
    );
    pattern_data.set_scrolling(scrolling);

    const PatternRepeatMode repeat_mode = LuaTools::opt_enum_field<PatternRepeatMode>(
        l, 1, "repeat_mode", PatternRepeatMode::ALL
    );
    pattern_data.set_repeat_mode(repeat_mode);

    const int frame_delay = LuaTools::opt_int_field(
        l, 1, "frame_delay", TilePatternData::default_frame_delay
    );
    pattern_data.set_frame_delay(frame_delay);

    std::vector<int> x;
    lua_settop(l, 1);
    lua_getfield(l, 1, "x");
    if (lua_isnumber(l, 2)) {
      // Single frame.
      x.push_back(LuaTools::check_int(l, 2));
    }
    else if (lua_istable(l, 2)) {
      // Multi-frame.
      lua_pushnil(l);
      while (lua_next(l, 2) != 0) {
        x.push_back(LuaTools::check_int(l, 4));
        lua_pop(l, 1);
      }
    }
    else {
      LuaTools::type_error(l, 2, "number or table");
    }
    lua_pop(l, 1);
    Debug::check_assertion(lua_gettop(l) == 1, "Invalid stack when parsing tile pattern");

    std::vector<int> y;
    lua_getfield(l, 1, "y");
    if (lua_isnumber(l, 2)) {
      // Single frame.
      y.push_back(LuaTools::check_int(l, 2));
    }
    else if (lua_istable(l, 2)) {
      // Multi-frame.
      lua_pushnil(l);
      while (lua_next(l, 2) != 0) {
        y.push_back(LuaTools::check_int(l, 4));
        lua_pop(l, 1);
      }
    }
    else {
      LuaTools::type_error(l, 2, "number or table");
    }
    lua_pop(l, 1);
    Debug::check_assertion(lua_gettop(l) == 1, "Invalid stack when parsing tile pattern");

    if (x.size() != y.size()) {
      LuaTools::arg_error(l, 1, "The length of x and y must match");
    }
    if (x.size() == 0) {
      LuaTools::arg_error(l, 1, "Missing x and y frame coordinates");
    }

    const int width = LuaTools::check_int_field(l, 1, "width");
    const int height = LuaTools::check_int_field(l, 1, "height");

    std::vector<Rectangle> frames(x.size(), Rectangle(0, 0, width, height));
    for (int i = 0; i < static_cast<int>(x.size()); ++i) {
      frames[i].set_x(x[i]);
      frames[i].set_y(y[i]);
    }

    bool mirror_loop = LuaTools::opt_boolean_field(
        l, 1, "mirror_loop", false
    );
    // Detect 1.5 legacy mirror loop format
    // and replace it by the mirror_loop boolean.
    if (frames.size() == 4 && frames[1] == frames[3]) {
      frames.pop_back();
      mirror_loop = true;
    }
    pattern_data.set_mirror_loop(mirror_loop);

    pattern_data.set_frames(frames);

    tileset_data.add_pattern(id, pattern_data);

    return 0;
  });
}

/**
 * \brief Function called by Lua to add a border set to the tileset.
 *
 * - Argument 1 (table): A table describing the border set to create.
 *
 * \param l The Lua context that is calling this function.
 * \return Number of values to return to Lua.
 */
int l_border_set(lua_State* l) {

  return LuaTools::exception_boundary_handle(l, [&] {
    lua_getfield(l, LUA_REGISTRYINDEX, "tileset");
    TilesetData& tileset_data = *static_cast<TilesetData*>(lua_touserdata(l, -1));
    lua_pop(l, 1);

    BorderSet border_set;

    const std::string& id = LuaTools::check_string_field(l, 1, "id");

    bool inner = LuaTools::opt_boolean_field(l, 1, "inner", false);
    border_set.set_inner(inner);

    std::map<BorderKind, std::string> patterns;
    for (int i = 0; i < 12; ++i) {
      std::ostringstream oss;
      oss << "pattern_" << i;
      const std::string& pattern_id = LuaTools::opt_string_field(l, 1, oss.str(), "");
      if (!pattern_id.empty()) {
        BorderKind border_kind = static_cast<BorderKind>(i);
        border_set.set_pattern(border_kind, pattern_id);
      }
    }

    tileset_data.add_border_set(id, border_set);

    return 0;
  });
}

}  // Anonymous namespace.

/**
 * \copydoc LuaData::import_from_lua
 */
bool TilesetData::import_from_lua(lua_State* l) {

  clear();
  lua_pushlightuserdata(l, this);
  lua_setfield(l, LUA_REGISTRYINDEX, "tileset");
  lua_register(l, "background_color", l_background_color);
  lua_register(l, "tile_pattern", l_tile_pattern);
  lua_register(l, "border_set", l_border_set);
  if (lua_pcall(l, 0, 0, 0) != 0) {
    Debug::error(std::string("Failed to load tileset: ") + lua_tostring(l, -1));
    lua_pop(l, 1);
    return false;
  }

  return true;
}

/**
 * \copydoc LuaData::export_to_lua
 */
bool TilesetData::export_to_lua(std::ostream& out) const {

  // Background color.
  uint8_t r, g, b, a;
  background_color.get_components(r, g, b, a);
  out << "background_color{ "
      << static_cast<int>(r)
      << ", "
      << static_cast<int>(g)
      << ", "
      << static_cast<int>(b)
      << " }\n";

  // Tile patterns.
  for (const auto& kvp : patterns) {
    const std::string& id = kvp.first;
    const TilePatternData& pattern = kvp.second;

    const Rectangle& first_frame = pattern.get_frame();
    int width = first_frame.get_width();
    int height = first_frame.get_height();
    std::ostringstream x;
    std::ostringstream y;
    if (!pattern.is_multi_frame()) {
      x << first_frame.get_x();
      y << first_frame.get_y();
    }
    else {
      x << "{ ";
      y << "{ ";
      bool first = true;
      for (const Rectangle& frame : pattern.get_frames()) {
        if (first) {
          first = false;
        }
        else {
          x << ", ";
          y << ", ";
        }
        x << frame.get_x();
        y << frame.get_y();
      }
      x << " }";
      y << " }";
    }

    const std::string& ground_name = enum_to_name(pattern.get_ground());
    int default_layer = static_cast<int>(pattern.get_default_layer());

    out << "tile_pattern{\n"
        << "  id = \"" << escape_string(id) << "\",\n"
        << "  ground = \"" << ground_name << "\",\n"
        << "  default_layer = " << default_layer << ",\n"
        << "  x = " << x.str() << ",\n"
        << "  y = " << y.str() << ",\n"
        << "  width = " << width << ",\n"
        << "  height = " << height << ",\n";
    if (pattern.is_multi_frame()) {
      out << "  frame_delay = " << pattern.get_frame_delay() << ",\n";
      if (pattern.is_mirror_loop()) {
        out << "  mirror_loop = true,\n";
      }
    }
    if (pattern.get_scrolling() != PatternScrolling::NONE) {
      const std::string& scrolling_name = enum_to_name(pattern.get_scrolling());
      out << "  scrolling = \"" << scrolling_name << "\",\n";
    }
    if (pattern.get_repeat_mode() != PatternRepeatMode::ALL) {
      const std::string& repeat_mode_name = enum_to_name(pattern.get_repeat_mode());
      out << "  repeat_mode = \"" << repeat_mode_name << "\",\n";
    }
    out << "}\n\n";
  }

  // Border sets.
  for (const auto& kvp : border_sets) {
    const std::string& id = kvp.first;
    const BorderSet& border_set = kvp.second;

    out << "border_set{\n"
        << "  id = \"" << escape_string(id) << "\",\n";
    if (border_set.is_inner()) {
      out << "  inner = true,\n";
    }
    for (int i = 0; i < 12; ++i) {
      BorderKind border_kind = static_cast<BorderKind>(i);
      const std::string& pattern_id = border_set.get_pattern(border_kind);
      if (!pattern_id.empty()) {
        out << "  pattern_" << i << " = \"" << pattern_id << "\",\n";
      }
    }

    out << "}\n\n";
  }

  return true;
}

}
