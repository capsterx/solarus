#pragma once

#include "solarus/graphics/SurfacePtr.h"
#include "solarus/core/Rectangle.h"
#include "solarus/core/Debug.h"
#include "solarus/graphics/BlendMode.h"
#include "solarus/graphics/Color.h"
#include "solarus/core/Scale.h"

#include <SDL_render.h>
#include <array>
#include <cmath>

namespace Solarus {

struct DrawProxy;

/**
 * @brief Struct used to pass drawing arguments trough the drawing pipeline
 *
 * It contains all the information needed to perform a draw of a drawable to another,
 *
 * it also provide some helper methods to extract useful informations from the drawing data
 */
struct DrawInfos {
  inline constexpr DrawInfos(const Rectangle& region,const Point& dst_position, const Point& transformation_origin,
            BlendMode blend_mode, uint8_t opacity, double rotation, const Scale& scale, const Color& color,
            const DrawProxy& proxy):
    region(region),dst_position(dst_position), transformation_origin(transformation_origin),
    scale(scale),proxy(proxy),
    color(color),
    rotation(rotation),blend_mode(blend_mode) ,opacity(opacity)
     {}
  inline constexpr DrawInfos(const Rectangle& region,const Point& dst_position, const Point& transformation_origin,
            BlendMode blend_mode, uint8_t opacity, double rotation, const Scale& scale,
            const DrawProxy& proxy):
    DrawInfos(region,dst_position,transformation_origin,blend_mode,opacity,rotation,scale,Color::white,proxy)
     {}
  inline constexpr DrawInfos(const DrawInfos& other, const DrawProxy& proxy) :
    DrawInfos(other.region,other.dst_position,other.transformation_origin,other.blend_mode,other.opacity,other.rotation,other.scale,other.color,proxy) {}
  inline constexpr DrawInfos(const DrawInfos &other, const Rectangle& region,
            const Point& dst_position) :
    DrawInfos(region,dst_position,other.transformation_origin,other.blend_mode,other.opacity,other.rotation,other.scale,other.color,other.proxy) {}
  inline constexpr DrawInfos(const DrawInfos &other, const Point& dst_position) :
    DrawInfos(other.region,dst_position,other.transformation_origin,other.blend_mode,other.opacity,other.rotation,other.scale,other.color,other.proxy) {}
  inline constexpr DrawInfos(const DrawInfos& other,uint8_t opacity):
    DrawInfos(other.region,other.dst_position,other.transformation_origin,other.blend_mode,opacity,other.rotation,other.scale,other.color,other.proxy) {}

  /**
   * @brief compute scaled destination rectangle
   * @return
   */
  inline Rectangle dst_rectangle() const {
    const Point& ototl = -transformation_origin;
    Point otobr = Point(region.get_size()) - transformation_origin;
    Point tcenter = dst_position+transformation_origin;
    return Rectangle(
          tcenter + ototl*scale,
          tcenter + otobr*scale
          ).positive();
  }

  inline SDL_RendererFlip flips() const {
    return (SDL_RendererFlip)((scale.x < 0.f ? SDL_FLIP_HORIZONTAL : SDL_FLIP_NONE) |
        (scale.y < 0.f ? SDL_FLIP_VERTICAL : SDL_FLIP_NONE));
  }

  /**
   * @brief compute sdl_origin for use with SDL_RenderCopyEx
   * @return
   */
  inline SDL_Point sdl_origin() const {
    return {(int)(transformation_origin.x*scale.x),(int)(transformation_origin.y*scale.y)};
  }

  inline bool should_use_ex() const {
    return std::fabs(rotation) > 1e-3 || scale.x < 0.f || scale.y < 0.f;
  }

  const Rectangle& region; /**< The region of the source surface that will be drawn*/
  const Point& dst_position; /**< The position in the target surface where the surface will be drawn */
  const Point transformation_origin; /** < The origin of the rotation and scale */
  const Scale& scale; /** < The object scale */
  const DrawProxy& proxy; /**< proxy that drawer should use when drawing */
  const Color& color = Color::white;
  double rotation; /**< The object rotation */
  BlendMode blend_mode; /**< blend mode that will be used */
  uint8_t   opacity; /**< opacity modulator */
};

/**
 * @brief The DrawProxy is used to draw with various modifiers
 *
 * This interface is usefull to pass draw technique down the drawing calls, specifically
 * in Sprite where with calls up to SpriteAnimationDirection, the DrawProxies receive
 * draw information bundled in Drawinfos and use them to perform final drawing
 */
struct DrawProxy {
  /**
   * @brief draw src_surface to dst_surface using given draw infos, potentially modifying the infos
   * @param dst_surface the target surface that will be written to
   * @param src_surface the src surface that will be read
   * @param params draw parameters packed into a DrawInfos struct
   *
   * The proxy field of the DrawInfos struct represent the next proxy to be applied, the proxies that
   * don't use this parameters are called 'terminals' as they terminate the draw operation. As I write
   * It's either a surface draw or a shader draw.
   */
  virtual void draw(Surface& dst_surface, const Surface& src_surface,const DrawInfos& params) const = 0;
  virtual inline ~DrawProxy(){}
};

namespace {
  struct NullProxy : DrawProxy {
    inline void draw(Surface&, const Surface&, const DrawInfos&) const override {
      //Does strictly nothing
      Debug::error("Draw with null proxy!");
    }
  };

  NullProxy null_proxy;
}

template<std::size_t N>
/**
 * @brief Defines a chain of proxies to be applied
 *
 * Used to chain various draw proxies together, in most cases, proxies.back should be a
 * terminal
 */
struct DrawProxyChain : DrawProxy {
  using Proxies = std::array<std::reference_wrapper<const DrawProxy>,N>;
  inline constexpr DrawProxyChain(const Proxies& proxies) : proxies(proxies) {
  }

  /**
   * \copydoc DrawProxy::draw
   */
  inline void draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& params) const override {
    proxies.front().get().draw(dst_surface,src_surface,DrawInfos(params,Link{*this,1}));
  }
private:
  /**
   * @brief DrawProxyChain link, that goes trough the array of proxies
   */
  struct Link : DrawProxy {
    inline constexpr Link(const DrawProxyChain& pipeline, size_t index) :
      pipeline(pipeline), index(index) {}
    inline void draw(Surface& dst_surface, const Surface& src_surface, const DrawInfos& params) const override {
        pipeline.proxies.at(index).get().draw(dst_surface,src_surface,DrawInfos(params,Link{pipeline,index+1}));
    }
  private:
    const DrawProxyChain& pipeline;
    size_t index;
  };
  const Proxies& proxies;
};

}
// DRAWPROXIES_H
