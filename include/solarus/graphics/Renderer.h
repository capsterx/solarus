#pragma once
#include <memory>
#include <solarus/graphics/SurfaceImpl.h>
#include <solarus/graphics/DrawProxies.h>
#include <solarus/graphics/SDLPtrs.h>
#include <solarus/graphics/Color.h>
#include <solarus/graphics/Drawable.h>

namespace Solarus {

class Renderer
{
public:
  explicit Renderer();
  virtual SurfaceImplPtr create_texture(int width, int height) = 0;
  virtual SurfaceImplPtr create_texture(SDL_Surface_UniquePtr&& surface) = 0;
  virtual SurfaceImplPtr create_window_surface(SDL_Window* window, int width, int height) = 0;
  virtual ShaderPtr create_shader(const std::string& shader_id) = 0;
  virtual ShaderPtr create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) = 0;
  virtual void set_render_target(SurfaceImpl& texture) = 0;
  virtual void draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) = 0;
  virtual void clear(SurfaceImpl& dst) = 0;
  virtual void fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode = BlendMode::BLEND) = 0;
  virtual std::string get_name() const = 0;
  virtual const DrawProxy& default_terminal() const = 0;
  virtual void render(SDL_Window* window, const SurfacePtr& quest_surface, const ShaderPtr& ptr = nullptr) = 0;
  virtual void present(SDL_Window* window) = 0;
  virtual void on_window_size_changed(const Rectangle& viewport) = 0;
  /*template<class T> T& as() {
    auto p = dynamic_cast<T*>(this); //TODO check if reinterpret cast is safe
    assert(p);
    return *p;
  }*/
  virtual void invalidate(const SurfaceImpl& surf) = 0;
  virtual ~Renderer();
};

using RendererPtr = std::unique_ptr<Renderer>;

}
