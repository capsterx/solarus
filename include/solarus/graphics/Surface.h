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
#ifndef SOLARUS_SURFACE_H
#define SOLARUS_SURFACE_H

#include "solarus/core/Common.h"
#include "solarus/core/PixelBits.h"
#include "solarus/graphics/SurfacePtr.h"
#include "solarus/graphics/Drawable.h"
#include "solarus/graphics/SurfaceImpl.h"
#include "solarus/graphics/SDLPtrs.h"

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace Solarus {

class Color;
class Size;
class SoftwarePixelFilter;
class Surface;

/**
 * \brief Represents a graphic surface.
 *
 * A surface is a rectangle of pixels.
 * A surface can be drawn or blitted on another surface.
 * This class basically encapsulates a library-dependent surface object.
 */
class Surface: public Drawable {

    friend class Shader;
    friend class VertexArray; // TODO find cleaner way

  public:
    /**
     * \brief The base directory to use when opening image files.
     */
    enum ImageDirectory {
      DIR_DATA,        /**< The root directory of the data package. */
      DIR_SPRITES,     /**< The sprites subdirectory of the data package (default). */
      DIR_LANGUAGE     /**< The language-specific image directory of the data package, for the current language. */
    };

    explicit Surface(SurfaceImplPtr impl, bool premultiplied = false);
    explicit Surface(SDL_Surface_UniquePtr surf, bool premultiplied = false);
    Surface(int width, int height, bool premultiplied = true);

    ~Surface();

    static SurfacePtr create(int width, int height, bool premultiplied = true);
    static SurfacePtr create(const Size& size, bool premultiplied = true);
    static SurfacePtr create(const std::string& file_name,
        ImageDirectory base_directory = DIR_SPRITES, bool premultiplied = false);
    static SurfacePtr create(SurfaceImplPtr impl, bool premultiplied = false);
    static SurfacePtr create(SDL_Surface_UniquePtr surf, bool premultiplied = false);

    static SDL_Surface_UniquePtr create_sdl_surface_from_file(
        const std::string& file_name
    );

    int get_width() const;
    int get_height() const;
    virtual Size get_size() const override;

    void clear();
    void clear(const Rectangle& where);
    void fill_with_color(const Color& color);
    void fill_with_color(const Color& color, const Rectangle& where);

    SurfaceImpl& get_impl();
    const SurfaceImpl& get_impl() const;

    bool is_pixel_transparent(int index) const;

    std::string get_pixels() const;
    void set_pixels(const std::string& buffer);

    // Implementation from Drawable.
    virtual void raw_draw(
        Surface& dst_surface,
        const DrawInfos& infos
    ) const override;

    virtual void raw_draw_region(
        Surface& dst_surface,
        const DrawInfos& infos
    ) const override;

    virtual Rectangle get_region() const override;

    void apply_pixel_filter(
        const SoftwarePixelFilter& pixel_filter, Surface& dst_surface) const;

    void bind_as_texture() const;
    void bind_as_target();

    const std::string& get_lua_type_name() const override;

    static void empty_cache();
  private:
    static SurfaceImplPtr get_surface_from_file(
        const std::string& file_name,
        ImageDirectory base_directory);

    SurfaceImplPtr internal_surface;                 /**< The SDL_Surface encapsulated. */
};

}

#endif

