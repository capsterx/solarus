#include "solarus/graphics/glrenderer/GlSurfaceImpl.h"
#include "solarus/graphics/glrenderer/GlRenderer.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/Video.h"
#include <SDL_render.h>

namespace Solarus {

GlSurfaceImpl::GlSurfaceImpl(SDL_Renderer *renderer, int width, int height, bool screen_tex) : target(true) {

}

GlSurfaceImpl::GlSurfaceImpl(SDL_Renderer* renderer, SDL_Surface_UniquePtr surface)
  : target(false), surface(std::move(surface)) {
  SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, this->surface.get());
  Debug::check_assertion(tex != nullptr,
        std::string("Failed to convert surface to texture") + SDL_GetError());
  texture.reset(tex);
}

/**
 * @brief upload potentially modified surface
 *
 * When modifying pixels of the Surface, we have
 * to upload it to the texture for changes to be reflected
 */
void GlSurfaceImpl::upload_surface() {
  Rectangle rect(0,0,get_width(),get_height());
  SDL_Surface* surface = get_surface();
  SDL_UpdateTexture(get_texture(),
                    rect,
                    surface->pixels,
                    surface->pitch
                    );
}

/**
 * \copydoc SurfaceImpl::get_texture
 */
SDL_Texture* GlSurfaceImpl::get_texture() const {
    return texture.get();
}

/**
 * \copydoc SurfaceImpl::get_surface
 */
SDL_Surface* GlSurfaceImpl::get_surface() const {
  if (target and surface_dirty) {
    /*GlRenderer::get().set_render_target(get_texture());
    SOLARUS_CHECK_SDL(SDL_RenderReadPixels(GlRenderer::get().renderer,
                         NULL,
                         Video::get_pixel_format()->format,
                         surface->pixels,
                         surface->pitch
                         ));
    surface_dirty = false;*/
  }
  return surface.get();
}

GlSurfaceImpl& GlSurfaceImpl::targetable()  {
  /*if(target) {
    surface_dirty = true;
    return *this;
  } else if(texture) { //Don't create texture for screen special case
    //Recreate texture
    auto& r = GlRenderer::get();
    SDL_Texture* tex = create_texture_from_renderer(r.renderer,get_width(),get_height());
    r.set_render_target(tex);
    SDL_SetTextureBlendMode(get_texture(),SDL_BLENDMODE_NONE);
    SDL_RenderCopy(r.renderer,get_texture(),nullptr,nullptr);
    texture.reset(tex);
  }
  return *this;*/
}

std::string GlSurfaceImpl::get_pixels() const {
  const size_t num_pixels = static_cast<size_t>(get_width() * get_height());
  SDL_Surface* surface = get_surface();

  if (surface->format->format == SDL_PIXELFORMAT_ABGR8888) {
    // No conversion needed.
    const char* buffer = static_cast<const char*>(surface->pixels);
    return std::string(buffer, num_pixels * surface->format->BytesPerPixel);
  }

  // Convert to RGBA format. Should never happen
  SDL_PixelFormat* format = Video::get_pixel_format();
  SDL_Surface_UniquePtr converted_surface(SDL_ConvertSurface(
                                            surface,
                                            format,
                                            0
                                            ));
  Debug::check_assertion(converted_surface != nullptr,
                         std::string("Failed to convert pixels to RGBA format") + SDL_GetError());
  const char* buffer = static_cast<const char*>(converted_surface->pixels);
  return std::string(buffer, num_pixels * converted_surface->format->BytesPerPixel);
}

void GlSurfaceImpl::set_pixels(const std::string& buffer) {
  if (surface->format->format == SDL_PIXELFORMAT_ABGR8888) {
    // No conversion needed.
    char* pixels = static_cast<char*>(surface->pixels);
    std::copy(buffer.begin(), buffer.end(), pixels);
    upload_surface();
    return;
  }
  //Should never happen
  Debug::error("Set pixel on a surface with bad format");
}

void GlSurfaceImpl::apply_pixel_filter(const SoftwarePixelFilter& pixel_filter, SurfaceImpl& a_dst_surface) const {

  /*SDLSurfaceImpl& dst_surface = a_dst_surface.as<SDLSurfaceImpl>();
  const int factor = pixel_filter.get_scaling_factor();
  Debug::check_assertion(dst_surface.get_width() == get_width() * factor,
      "Wrong destination surface size");
  Debug::check_assertion(dst_surface.get_height() == get_height() * factor,
      "Wrong destination surface size");

  SDL_Surface* src_internal_surface = get_surface();
  SDL_Surface* dst_internal_surface = dst_surface.get_surface();

  Debug::check_assertion(dst_internal_surface != nullptr,
      "Missing software destination surface for pixel filter");

  SDL_LockSurface(src_internal_surface);
  SDL_LockSurface(dst_internal_surface);

  uint32_t* src = static_cast<uint32_t*>(src_internal_surface->pixels);
  uint32_t* dst = static_cast<uint32_t*>(dst_internal_surface->pixels);

  pixel_filter.filter(src, get_width(), get_height(), dst);

  SDL_UnlockSurface(dst_internal_surface);
  SDL_UnlockSurface(src_internal_surface);
  dst_surface.upload_surface();*/
}

bool GlSurfaceImpl::is_pixel_transparent(int index) const {
  SDL_Surface* surface = get_surface();
  Debug::check_assertion(surface->format->BytesPerPixel == 4 and surface->format->Amask != 0, "Surface is not in RGBA format");
  uint32_t pixel = static_cast<uint32_t*>(surface->pixels)[index];
  return (pixel & surface->format->Amask) == 0;
}

/**
 * \copydoc SurfaceImpl::get_width
 */
int GlSurfaceImpl::get_width() const {
    return surface->w;
}

/**
 * \copydoc SurfaceImpl::get_height
 */
int GlSurfaceImpl::get_height() const {
    return surface->h;
}

}
