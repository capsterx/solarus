#pragma once

#include <solarus/graphics/Renderer.h>
#include <solarus/graphics/glrenderer/GlShader.h>
#include <solarus/graphics/VertexArray.h>

namespace Solarus {

#ifdef DEBUG
#define SOLARUS_CHECK_SDL_HIGHER(expr,bound) if((expr) < bound) Debug::error(std::string(SDL_GetError()) + "! " + __FILE__ + ":" + std::to_string(__LINE__));
#else
#define SOLARUS_CHECK_SDL_HIGHER(expr,bound) expr
#endif

#define SOLARUS_CHECK_SDL(expr) SOLARUS_CHECK_SDL_HIGHER(expr,0)

class GlShader;
class GlTexture;



class GlRenderer : public Renderer {
  friend class GlTexture;
  friend class GlShader;

public:
  struct GlFunctions {
    #define SDL_PROC(ret,func,params) ret (APIENTRY* func) params;
    #include "gles2funcs.h"
    #undef SDL_PROC
  };

  struct Fbo{
    GLuint id;
    glm::mat4 view;
  };

  GlRenderer(SDL_GLContext ctx);
  static RendererPtr create(SDL_Window* window);
  SurfaceImplPtr create_texture(int width, int height) override;
  SurfaceImplPtr create_texture(SDL_Surface_UniquePtr &&surface) override;
  SurfaceImplPtr create_window_surface(SDL_Window* w, int width, int height) override;
  ShaderPtr create_shader(const std::string& shader_id) override;
  ShaderPtr create_shader(const std::string& vertex_source, const std::string& fragment_source, double scaling_factor) override;
  void set_render_target(SurfaceImpl& texture) override;
  void set_render_target(GlTexture* target);
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

  const DrawProxy& default_terminal() const override;
  ~GlRenderer() override;
private:
  static constexpr const char* VCOLOR_ONLY_NAME = "sol_vcolor_only";
  void draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos, GlShader& shader);

  bool use_bmap() const;

  void restart_batch();
  void set_shader(GlShader* shader);
  void set_texture(const GlTexture* texture);
  void set_state(const GlTexture* src, GlShader* shad, GlTexture* dst, BlendMode mode);
  void set_blend_mode(BlendMode mode);
  void create_vbo(size_t num_sprites);
  void add_sprite(const DrawInfos& infos);
  size_t buffered_indices() const;
  size_t buffered_vertices() const;
  Fbo* get_fbo(int width, int height, bool screen = false);

  static GlRenderer* instance;
  static GlFunctions ctx;
  SDL_GLContext sdl_gl_context;
  GlShader* current_shader;
  const GlTexture* current_texture;
  GlTexture* current_target;
  BlendMode current_blend_mode;
  ShaderPtr main_shader;

  GLuint vbo;
  GLuint ibo;

  Vertex* current_vertex = nullptr;
  size_t buffered_sprites = 0;
  size_t buffer_size = 0;
  std::vector<Vertex> vertex_buffer;

  Fbo screen_fbo;
  std::unordered_map<size_t,Fbo> fbos;
  Rectangle window_viewport;
};
}
