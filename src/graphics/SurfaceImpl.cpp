#include "solarus/graphics/SurfaceImpl.h"
#include <solarus/core/Debug.h>
#include <solarus/graphics/Video.h>

namespace Solarus {

SurfaceImpl::~SurfaceImpl() {
  Video::invalidate(*this);
}

/**
 * @brief is_premultiplied
 * @return
 */
bool SurfaceImpl::is_premultiplied() const {
  return premultiplied;
}

/**
 * @brief set_premultiplied
 */
void SurfaceImpl::set_premultiplied(bool a_premultiplied) {
  premultiplied = a_premultiplied;
}

std::string SurfaceImpl::get_pixels() const {
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

void SurfaceImpl::set_pixels(const std::string& buffer) {
  auto surface = get_surface();
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

void SurfaceImpl::apply_pixel_filter(const SoftwarePixelFilter& pixel_filter, SurfaceImpl& dst_surface) const {
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
  dst_surface.upload_surface();
}

bool SurfaceImpl::is_pixel_transparent(int index) const {
  SDL_Surface* surface = get_surface();
  Debug::check_assertion(surface->format->BytesPerPixel == 4 and surface->format->Amask != 0, "Surface is not in RGBA format");
  uint32_t pixel = static_cast<uint32_t*>(surface->pixels)[index];
  return (pixel & surface->format->Amask) == 0;
}

}
