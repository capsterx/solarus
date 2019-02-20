#pragma once

#include "solarus/core/Rectangle.h"
#include "solarus/core/Point.h"
#include "solarus/graphics/SDLPtrs.h"
#include "solarus/graphics/SurfaceImpl.h"
#include "solarus/graphics/glrenderer/GlRenderer.h"

#include <memory>

namespace Solarus {

/**
 * @brief Abstract class for internal surface pixel representation and manipulation
 */
class GlTexture : public SurfaceImpl
{
  friend class GlRenderer;
public:
  GlTexture(int width, int height, bool screen_tex = false);
  GlTexture(SDL_Surface_UniquePtr surface);

  GLuint get_texture() const;
  SDL_Surface* get_surface() const override;

  GlTexture& targetable();

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
  void release() const;
  void set_texture_params();
  glm::mat3 uv_transform;
  mutable bool surface_dirty = true;
  GLuint tex_id = 0;
  GlRenderer::Fbo* fbo = nullptr;
  mutable SDL_Surface_UniquePtr surface = nullptr;
};

}
