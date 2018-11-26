#pragma once

#include "solarus/core/Rectangle.h"
#include "solarus/core/Point.h"
#include "solarus/graphics/SDLPtrs.h"
#include "solarus/graphics/SurfaceImpl.h"

#include <SDL_render.h>
#include <memory>

namespace Solarus {

class SDLRenderer;
/**
 * @brief Abstract class for internal surface pixel representation and manipulation
 */
class SDLSurfaceImpl : public SurfaceImpl
{
  friend class SDLRenderer;
public:
  SDLSurfaceImpl(SDL_Renderer* renderer, int width, int height, bool screen_tex = false);
  SDLSurfaceImpl(SDL_Renderer* renderer, SDL_Surface_UniquePtr surface);

  SDL_Texture* get_texture() const;
  SDL_Surface* get_surface() const override;

  SDLSurfaceImpl& targetable();

  int get_width() const override;
  int get_height() const override;

  /**
   * @brief upload potentially modified surface
   *
   * When modifying pixels of the Surface, we have
   * to upload it to the texture for changes to be reflected
   */
  void upload_surface() override;
private:
  bool target = false;
  mutable bool surface_dirty = true;
  mutable SDL_Texture_UniquePtr texture;
  mutable SDL_Surface_UniquePtr surface;
};

}
