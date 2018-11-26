#include "solarus/graphics/sdlrenderer/SDLSurfaceImpl.h"
#include "solarus/graphics/sdlrenderer/SDLRenderer.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/Video.h"
#include <SDL_render.h>

namespace Solarus {

SDL_Texture* create_texture_from_renderer(SDL_Renderer* renderer, int width, int height) {
  SDL_PixelFormat* format = Video::get_pixel_format();

  Debug::check_assertion(renderer != nullptr, "Missing renderer");
  Debug::check_assertion(format != nullptr, "Missing RGBA pixel format");

  SDL_Texture* tex = SDL_CreateTexture(
      renderer,
      Video::get_pixel_format()->format,
      SDL_TEXTUREACCESS_TARGET,
      width,
      height);
  Debug::check_assertion(tex != nullptr,
                         std::string("Failed to create render texture : ") + SDL_GetError());
  return tex;
}

SDLSurfaceImpl::SDLSurfaceImpl(SDL_Renderer *renderer, int width, int height, bool screen_tex) : target(true) {
  texture.reset(screen_tex ? nullptr : create_texture_from_renderer(renderer,width,height));

  SDL_PixelFormat* format = Video::get_pixel_format();
  SDL_Surface* surf_ptr = SDL_CreateRGBSurface(
       0,
       width,
       height,
       32,
       format->Rmask,
       format->Gmask,
       format->Bmask,
       format->Amask);
  Debug::check_assertion(surf_ptr != nullptr,
                         std::string("Failed to create backup surface ") + SDL_GetError());
  surface.reset(surf_ptr);
}

SDLSurfaceImpl::SDLSurfaceImpl(SDL_Renderer* renderer, SDL_Surface_UniquePtr surface)
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
void SDLSurfaceImpl::upload_surface() {
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
SDL_Texture* SDLSurfaceImpl::get_texture() const {
    return texture.get();
}

/**
 * \copydoc SurfaceImpl::get_surface
 */
SDL_Surface* SDLSurfaceImpl::get_surface() const {
  if (target and surface_dirty) {
    SDLRenderer::get().set_render_target(get_texture());
    SOLARUS_CHECK_SDL(SDL_RenderReadPixels(SDLRenderer::get().renderer,
                         NULL,
                         Video::get_pixel_format()->format,
                         surface->pixels,
                         surface->pitch
                         ));
    surface_dirty = false;
  }
  return surface.get();
}

SDLSurfaceImpl& SDLSurfaceImpl::targetable()  {
  if(target) {
    surface_dirty = true;
    return *this;
  } else if(texture) { //Don't create texture for screen special case
    //Recreate texture
    auto& r = SDLRenderer::get();
    SDL_Texture* tex = create_texture_from_renderer(r.renderer,get_width(),get_height());
    r.set_render_target(tex);
    SDL_SetTextureBlendMode(get_texture(),SDL_BLENDMODE_NONE);
    SDL_RenderCopy(r.renderer,get_texture(),nullptr,nullptr);
    texture.reset(tex);
  }
  return *this;
}

/**
 * \copydoc SurfaceImpl::get_width
 */
int SDLSurfaceImpl::get_width() const {
    return surface->w;
}

/**
 * \copydoc SurfaceImpl::get_height
 */
int SDLSurfaceImpl::get_height() const {
    return surface->h;
}

}
