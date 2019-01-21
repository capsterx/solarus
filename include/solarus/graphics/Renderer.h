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


  /**
   * @brief draw a surface on another
   * @param dst the destination surface
   * @param src the source surface
   * @param infos the draw parameters
   */
  virtual void draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) = 0;

  /**
   * @brief clear a surface
   * @param dst surface to clear
   */
  virtual void clear(SurfaceImpl& dst) = 0;

  /**
   * @brief fill a surface with a solid color
   * @param dst surface to fill
   * @param color color to use
   * @param where region to fill
   * @param mode mode to use when blitting color
   */
  virtual void fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode = BlendMode::BLEND) = 0;

  /**
   * @brief get this renderer name
   * @return the name
   */
  virtual std::string get_name() const = 0;

  /**
   * @brief get the default terminal of this renderer, meaning default DrawProxy, plain draw
   * @return  the terminal
   */
  virtual const DrawProxy& default_terminal() const = 0;

  /**
   * @brief present the render result to the window
   * @param window the window
   */
  virtual void present(SDL_Window* window) = 0;

  /**
   * @brief event called when the window is resized
   * @param viewport the region of the window that should be the renderer output
   */
  virtual void on_window_size_changed(const Rectangle& viewport) = 0;

  /**
   * @brief tells the renderer that a surface has been freed
   * @param surf the freed surface
   */
  virtual void invalidate(const SurfaceImpl& surf) = 0;

  /**
   * @brief bind a surface as opengl target
   * @param surf the surface to bind
   */
  virtual void bind_as_gl_target(SurfaceImpl& surf) = 0;

  /**
   * @brief bind a surface as opengl texture
   * @param surf the surface to bind
   */
  virtual void bind_as_gl_texture(const SurfaceImpl& surf) = 0;

  /**
   * @brief tells if this renderer needs the window to be shown to operate on
   *  offscreen textures
   * @return
   */
  virtual bool needs_window_workaround() const {
    return false;
  }
  virtual ~Renderer();
};

using RendererPtr = std::unique_ptr<Renderer>;

}
