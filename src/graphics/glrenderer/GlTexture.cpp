#include "solarus/graphics/glrenderer/GlTexture.h"
#include "solarus/graphics/glrenderer/GlRenderer.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/Video.h"

#include <glm/gtx/matrix_transform_2d.hpp>
#include <SDL_render.h>

namespace Solarus {

inline glm::mat3 uv_view(int width, int height,bool flip = false) {
  using namespace glm;
  (void)flip;
  /*if(!flip)
    return scale(translate(mat3(),vec2(0,1)),vec2(1.f/width,-1.f/height));
  else*/
    return scale(mat3(),vec2(1.f/width,1.f/height));
}

GlTexture::GlTexture(int width, int height, bool screen_tex)
  : target(true),
    uv_transform(uv_view(width,height)),
    fbo(GlRenderer::get().get_fbo(width,height,screen_tex)) {
  const auto& ctx = GlRenderer::ctx;
  ctx.glGenTextures(1,&tex_id);
  ctx.glBindTexture(GL_TEXTURE_2D,tex_id);
  ctx.glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,nullptr);

  set_texture_params();
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
  GlRenderer::get().rebind_texture();
}

GlTexture::GlTexture(SDL_Surface_UniquePtr a_surface)
  : target(false),
    uv_transform(uv_view(a_surface->w,a_surface->h,true)),
    surface(std::move(a_surface)) {
  const auto& ctx = GlRenderer::ctx;
  int width = surface->w;
  int height = surface->h;
  ctx.glGenTextures(1,&tex_id);
  ctx.glBindTexture(GL_TEXTURE_2D,tex_id);
  ctx.glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,surface->pixels);
  set_texture_params();
  GlRenderer::get().rebind_texture();
  //TODO check that pixels are in the right order
}

void GlTexture::set_texture_params() {
  const auto& ctx = GlRenderer::ctx;
  ctx.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  ctx.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  ctx.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  ctx.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
}

/**
 * @brief upload potentially modified surface
 *
 * When modifying pixels of the Surface, we have
 * to upload it to the texture for changes to be reflected
 */
void GlTexture::upload_surface() {
  Rectangle rect(0,0,get_width(),get_height());
  SDL_Surface* surface = get_surface();
  const auto& ctx = GlRenderer::ctx;
  ctx.glBindTexture(GL_TEXTURE_2D,tex_id);
  ctx.glTexSubImage2D(GL_TEXTURE_2D,
                      0,
                      0,0,
                      get_width(),get_height(),
                      GL_RGBA,GL_UNSIGNED_BYTE,
                      surface->pixels);
  GlRenderer::get().rebind_texture();
}

/**
 * \copydoc SurfaceImpl::get_texture
 */
GLuint GlTexture::get_texture() const {
  return tex_id;
}

/**
 * \copydoc SurfaceImpl::get_surface
 */
SDL_Surface* GlTexture::get_surface() const {
  if (target and surface_dirty) {
    const auto& ctx = GlRenderer::ctx;
    GlRenderer::get().set_render_target(const_cast<GlTexture*>(this));
    ctx.glReadPixels(0,0, //TODO check read y order
                     get_width(),get_height(),
                     GL_RGBA,
                     GL_UNSIGNED_BYTE,
                     surface->pixels);
  }
  return surface.get();
}

GlTexture& GlTexture::targetable()  {
  surface_dirty = true; //Just tag the surface as outdated
  if(!fbo)
    fbo = GlRenderer::get().get_fbo(get_width(),get_height());
  return *this;
}

/**
 * \copydoc SurfaceImpl::get_width
 */
int GlTexture::get_width() const {
  return surface->w;
}

/**
 * \copydoc SurfaceImpl::get_height
 */
int GlTexture::get_height() const {
  return surface->h;
}

GlTexture::~GlTexture() {
  glDeleteTextures(1,&tex_id);
}

}
