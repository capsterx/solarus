#pragma once

#include <SDL_render.h>
#include <solarus/graphics/Renderer.h>


namespace Solarus {

#ifdef DEBUG
#define SOLARUS_CHECK_SDL_HIGHER(expr,bound) if((expr) < bound) Debug::error(std::string(SDL_GetError()) + "! " + __FILE__ + ":" + std::to_string(__LINE__));
#else
#define SOLARUS_CHECK_SDL_HIGHER(expr,bound) expr
#endif

#define SOLARUS_CHECK_SDL(expr) SOLARUS_CHECK_SDL_HIGHER(expr,0)

class GlRenderer : public Renderer {
  friend class SDLSurfaceImpl;
  friend class SDLShader;

public:
  GlRenderer(SDL_Renderer* window);
  static RendererPtr create(SDL_Window* window);
  SurfaceImplPtr create_texture(int width, int height) override;
  SurfaceImplPtr create_texture(SDL_Surface_UniquePtr &&surface) override;
  SurfaceImplPtr create_window_surface(SDL_Window* w, int width, int height) override;
  ShaderPtr create_shader(const std::string& shader_id) override;
  ShaderPtr create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) override;
  void set_render_target(SurfaceImpl& texture) override;
  void set_render_target(SDL_Texture* target);
  void draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) override;
  void clear(SurfaceImpl& dst) override;
  void fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode = BlendMode::BLEND) override;
  void invalidate(const SurfaceImpl& surf) override;
  std::string get_name() const override;
  void render(SDL_Window* window, const SurfacePtr& quest_surface, const ShaderPtr &shader = nullptr) override;
  void present(SDL_Window* window) override;
  void on_window_size_changed(const Rectangle& viewport) override;
  static GlRenderer& get(){
    return *instance;
  }
  const DrawProxy& default_terminal() const override {

  }
  ~GlRenderer() override;
private:
  static GlRenderer* instance;

  SDL_Surface_UniquePtr software_screen;
  SDL_Texture*  render_target = nullptr;
  bool valid_target = false;
  SDL_Renderer* renderer;
};
}
