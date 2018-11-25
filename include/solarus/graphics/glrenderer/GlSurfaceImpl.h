#pragma once

#include "solarus/core/Rectangle.h"
#include "solarus/core/Point.h"
#include "solarus/graphics/SDLPtrs.h"
#include "solarus/graphics/SurfaceImpl.h"

#include <SDL_render.h>
#include <memory>

namespace Solarus {

/**
 * @brief Abstract class for internal surface pixel representation and manipulation
 */
class GlSurfaceImpl : public SurfaceImpl
{
  friend class GlRenderer;
public:
  GlSurfaceImpl(SDL_Renderer* renderer, int width, int height, bool screen_tex = false);
  GlSurfaceImpl(SDL_Renderer* renderer, SDL_Surface_UniquePtr surface);

  SDL_Texture* get_texture() const;
  SDL_Surface* get_surface() const;

  GlSurfaceImpl& targetable();

  int get_width() const override;
  int get_height() const override;

  std::string get_pixels() const override;

  void set_pixels(const std::string& buffer) override;

  void apply_pixel_filter(const SoftwarePixelFilter& pixel_filter, SurfaceImpl& dst_surface) const override;
  bool is_pixel_transparent(int index) const override;

  /**
   * @brief upload potentially modified surface
   *
   * When modifying pixels of the Surface, we have
   * to upload it to the texture for changes to be reflected
   */
  void upload_surface();
private:
  bool target = false;
  mutable bool surface_dirty = true;
  mutable SDL_Texture_UniquePtr texture;
  mutable SDL_Surface_UniquePtr surface;
};

}
