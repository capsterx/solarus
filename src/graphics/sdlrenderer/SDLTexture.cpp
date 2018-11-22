#include "solarus/graphics/sdlrenderer/SDLTexture.h"
#include "solarus/graphics/sdlrenderer/SDLRenderTexture.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/Surface.h"

namespace Solarus {

/**
 * @brief Texture::Texture
 * @param surface valid sdl surface
 */
SDLTexture::SDLTexture(SDL_Surface_UniquePtr surface)
    : surface(std::move(surface))
{
  SDL_Texture* tex = SDL_CreateTextureFromSurface(Video::get_renderer(), this->surface.get());
  Debug::check_assertion(tex != nullptr,
        std::string("Failed to convert surface to texture") + SDL_GetError());
  texture.reset(tex);
}

/**
 * \copydoc SurfaceImpl::get_texture
 */
SDL_Texture* SDLTexture::get_texture() const {
    return texture.get();
}

/**
 * \copydoc SurfaceImpl::get_surface
 */
SDL_Surface* SDLTexture::get_surface() const {
    return surface.get();
}

/**
 * \copydoc SurfaceImpl::get_width
 */
int SDLTexture::get_width() const {
    return surface->w;
}

/**
 * \copydoc SurfaceImpl::get_height
 */
int SDLTexture::get_height() const {
    return surface->h;
}

/**
 * \copydoc SurfaceImpl::to_render_texture
 */
SDLRenderTexture* SDLTexture::to_render_texture() {
    SDLRenderTexture* rt = new SDLRenderTexture(get_width(),get_height());
    rt->draw_other(*this,DrawInfos(Rectangle(Point(),Size(get_width(),get_height())),
                                   Point(),
                                   Point(),
                                   BlendMode::NONE,255,
                                   0,Scale(),Surface::draw_proxy));
    return rt;
}

}
