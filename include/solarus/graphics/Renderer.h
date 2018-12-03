#pragma once
#include <memory>
#include <solarus/graphics/SurfaceImpl.h>
#include <solarus/graphics/DrawProxies.h>
#include <solarus/graphics/SDLPtrs.h>
#include <solarus/graphics/Color.h>
#include <solarus/graphics/Drawable.h>

namespace Solarus {

/**
 * @brief Abstraction of the rendering device
 *
 * All renderers will implement this interface
 */
class Renderer
{
public:
  explicit Renderer();

  /**
   * @brief Creates a surface implementation as rendertarget
   * @param width texture width
   * @param height texture height
   * @return the surface impl
   */
  virtual SurfaceImplPtr create_texture(int width, int height) = 0;

  /**
   * @brief Create a surface implementation as static texture
   * @param surface a SDL surface containing the pixels data, ownership is taken
   * @return the surface impl
   */
  virtual SurfaceImplPtr create_texture(SDL_Surface_UniquePtr&& surface) = 0;

  /**
   * @brief Create a special surface impl that represent the screen
   * @param window the window
   * @param width width of the render region
   * @param height height of the render region
   * @return the surface impl
   */
  virtual SurfaceImplPtr create_window_surface(SDL_Window* window, int width, int height) = 0;

  /**
   * @brief Create a shader from the shader id, loading it from disk
   * @param shader_id the shader id
   * @return the shader
   */
  virtual ShaderPtr create_shader(const std::string& shader_id) = 0;

  /**
   * @brief Create a shader from source
   * @param vertex_source vertex source
   * @param fragment_source fragment source
   * @param scaling_factor the scaling factor for this shader
   * @return the shader
   */
  virtual ShaderPtr create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) = 0;


  virtual void draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) = 0;
  virtual void clear(SurfaceImpl& dst) = 0;
  virtual void fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode = BlendMode::BLEND) = 0;
  virtual std::string get_name() const = 0;
  virtual const DrawProxy& default_terminal() const = 0;
  virtual void present(SDL_Window* window) = 0;
  virtual void on_window_size_changed(const Rectangle& viewport) = 0;

  virtual void invalidate(const SurfaceImpl& surf) = 0;
  virtual ~Renderer();
};

using RendererPtr = std::unique_ptr<Renderer>;

}
