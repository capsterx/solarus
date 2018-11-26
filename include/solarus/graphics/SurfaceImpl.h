#pragma once

#include "solarus/core/Rectangle.h"
#include "solarus/core/Point.h"
#include "solarus/graphics/SoftwarePixelFilter.h"

#include <SDL_render.h>
#include <memory>

namespace Solarus {

class Texture;
class RenderTexture;
class Surface;

/**
 * @brief Abstract class for internal surface pixel representation and manipulation
 */
class SurfaceImpl
{
public:
  /**
     * @brief get the synchronised SDL_Surface
     *
     * The SDL_Texture alone is not convenient to access, for pixel
     * perfect collisions and pixel access, we keep a surface as a
     * cache.
     *
     * @return a valid SDL_Surface
     */
  virtual SDL_Surface* get_surface() const = 0;

  /**
   * @brief upload_surface back to the accelerated storage
   */
  virtual void upload_surface() = 0;

  /**
     * @brief get texture width
     * @return width
     */
  virtual int get_width() const = 0;

  /**
     * @brief get texture height
     * @return height
     */
  virtual int get_height() const = 0;


  std::string get_pixels() const;
  void set_pixels(const std::string& buffer);

  void apply_pixel_filter(const SoftwarePixelFilter& pixel_filter, SurfaceImpl& dst_surface) const;
  bool is_pixel_transparent(int index) const;

  /**
     * @brief ~SurfaceImpl
     */
  virtual ~SurfaceImpl();

  bool is_premultiplied() const;
  void set_premultiplied(bool a_premultiplied);

  template<class T> T& as() {
    return *static_cast<T*>(this);
  }

  template<class T> const T& as() const {
    return *static_cast<const T*>(this);
  }
private:
  bool premultiplied = false;
};

using SurfaceImplPtr = std::shared_ptr<SurfaceImpl>;

}
