#include "solarus/graphics/RenderTexture.h"
#include "solarus/graphics/Surface.h"
#include "solarus/graphics/Shader.h"

namespace Solarus {

RenderTexture::RenderTexture(SDL_Texture* texture, int width, int height) {
  target.reset(texture);
  SDL_PixelFormat* format = Video::get_rgba_format();

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

/**
 * @brief RenderTexture::RenderTexture
 * @param width width of the render texture
 * @param height height of the render texture
 */
RenderTexture::RenderTexture(int width, int height)
{
  SDL_Renderer* renderer = Video::get_renderer();
  SDL_PixelFormat* format = Video::get_rgba_format();

  Debug::check_assertion(renderer != nullptr, "Missing renderer");
  Debug::check_assertion(format != nullptr, "Missing RGBA pixel format");

  SDL_Texture* tex = SDL_CreateTexture(
      renderer,
      Video::get_rgba_format()->format,
      SDL_TEXTUREACCESS_TARGET,
      width,
      height);
  Debug::check_assertion(tex != nullptr,
                         std::string("Failed to create render texture : ") + SDL_GetError());

  target.reset(tex);

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
  clear();
}

/**
 * \copydoc SurfaceImpl::get_width
 */
int RenderTexture::get_width() const {
  return surface->w;
}

/**
 * \copydoc SurfaceImpl::get_height
 */
int RenderTexture::get_height() const {
  return surface->h;
}

/**
 * \copydoc SurfaceImpl::get_texture
 */
SDL_Texture* RenderTexture::get_texture() const {
  return target.get();
}

/**
 * @brief draw other surface impl on this one using given infos
 * @param texture the surface to draw here
 * @param infos draw info bundle
 */
void RenderTexture::draw_other(const SurfaceImpl& texture, const DrawInfos& infos) {
  with_target([&](SDL_Renderer* renderer){
    Rectangle dst_rect = infos.dst_rectangle();
    if(!texture.get_texture()) {
      Debug::error("Could not draw screen on another surface");
    }

    SDL_BlendMode mode = Surface::make_sdl_blend_mode(*this,texture,infos.blend_mode);
    SOLARUS_CHECK_SDL_HIGHER(SDL_SetTextureBlendMode(texture.get_texture(),mode),-1);
    SOLARUS_CHECK_SDL(SDL_SetTextureAlphaMod(texture.get_texture(),infos.opacity));
    if(infos.should_use_ex()) {
      SDL_Point origin= infos.sdl_origin();
      SOLARUS_CHECK_SDL(SDL_RenderCopyEx(renderer,texture.get_texture(),infos.region,dst_rect,-infos.rotation*180/M_PI,&origin,SDL_FLIP_NONE));
    } else {
      SOLARUS_CHECK_SDL(SDL_RenderCopy(renderer,texture.get_texture(),infos.region,dst_rect));
    }
  });
}

/**
 * \copydoc SurfaceImpl::get_surface
 */
SDL_Surface *RenderTexture::get_surface() const {
  if (surface_dirty) {
    with_target([&](SDL_Renderer* renderer){
      SOLARUS_CHECK_SDL(SDL_RenderReadPixels(renderer,
                           NULL,
                           Video::get_rgba_format()->format,
                           surface->pixels,
                           surface->pitch
                           ));
    });
    surface_dirty = false;
  }
  return surface.get();
}

/**
 * \copydoc SurfaceImpl::to_render_texture
 */
RenderTexture* RenderTexture::to_render_texture() {
  return this;
}

/**
 * @brief fill a region of this surface with a color
 * @param color color
 * @param where region to fill
 * @param mode blend mode
 */
void RenderTexture::fill_with_color(const Color& color, const Rectangle& where, SDL_BlendMode mode) {
  const SDL_Rect* rect = where;
  with_target([&](SDL_Renderer* renderer){
    Uint8 r,g,b,a;
    color.get_components(r,g,b,a);
    SOLARUS_CHECK_SDL(SDL_SetRenderDrawColor(renderer,r,g,b,a));
    SOLARUS_CHECK_SDL(SDL_SetRenderDrawBlendMode(renderer,mode));
    SOLARUS_CHECK_SDL(SDL_RenderFillRect(renderer,rect));
  });
}

/**
 * @brief RenderTexture::clear
 */
void RenderTexture::clear() {
  with_target([&](SDL_Renderer* renderer){
    SOLARUS_CHECK_SDL(SDL_SetRenderDrawColor(renderer,0,0,0,0));
    SOLARUS_CHECK_SDL(SDL_SetTextureBlendMode(target.get(),SDL_BLENDMODE_BLEND));
    SOLARUS_CHECK_SDL(SDL_RenderClear(renderer));
  });
}

/**
 * @brief RenderTexture::clear
 * @param where region to clear
 */
void RenderTexture::clear(const Rectangle& where) {
  fill_with_color(Color::transparent,where,SDL_BLENDMODE_NONE);
}

}
