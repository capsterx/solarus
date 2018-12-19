#pragma once

#include <solarus/graphics/Renderer.h>
#include <solarus/graphics/glrenderer/GlShader.h>
#include <solarus/graphics/VertexArray.h>

namespace Solarus {

class GlShader;
class GlTexture;

/**
 * @brief Opengl Renderer
 *
 * This renderer implements batch rendering. This minimize the state changes in
 * the opengl driver. Sprites are accumulated in a buffer before being rendered
 * all at once.
 */
class GlRenderer : public Renderer {
  friend class GlTexture;
  friend class GlShader;

public:
  typedef void (APIENTRY *DEBUGPROC)(GLenum source,
              GLenum type,
              GLuint id,
              GLenum severity,
              GLsizei length,
              const GLchar *message,
              const void *userParam);

  /**
   * @brief Structure containing all usefull GlFunctions
   */
  struct GlFunctions {
    #define SDL_PROC(ret,func,params) ret (APIENTRY* func) params;
    #include "gles2funcs.h"
    #undef SDL_PROC
  };

  /**
   * @brief Draw destination
   */
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
  //void set_render_target(SurfaceImpl& texture) override;
  void set_render_target(GlTexture* target);
  void bind_as_gl_target(SurfaceImpl &surf) override;
  void bind_as_gl_texture(const SurfaceImpl& surf) override;
  void draw(SurfaceImpl& dst, const SurfaceImpl& src, const DrawInfos& infos) override;
  void clear(SurfaceImpl& dst) override;
  void fill(SurfaceImpl& dst, const Color& color, const Rectangle& where, BlendMode mode = BlendMode::BLEND) override;
  void invalidate(const SurfaceImpl& surf) override;
  std::string get_name() const override;
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

  /**
   * Blend mode aggregate
   */
  using GLBlendMode = std::tuple<GLenum,GLenum,GLenum,GLenum,bool>;


  bool use_vao() const;

  void read_pixels(GlTexture* from, void* to);
  void put_pixels(GlTexture* to, void* data);

  void restart_batch();
  void set_shader(GlShader* shader);
  void set_texture(const GlTexture* texture);
  void set_state(const GlTexture* src, GlShader* shad, GlTexture* dst, const GLBlendMode& mode, bool force = false);
  void rebind_texture();
  void rebind_shader();
  void set_blend_mode(GLBlendMode mode);
  GLBlendMode make_gl_blend_modes(const GlTexture &dst, const GlTexture *src, BlendMode mode);
  GLBlendMode make_gl_blend_modes(BlendMode mode);
  void create_vbo(size_t num_sprites);
  void add_sprite(const DrawInfos& infos);
  size_t buffered_indices() const;
  size_t buffered_vertices() const;
  Fbo* get_fbo(int width, int height, bool screen = false);

  void shader_about_to_change(GlShader* shader);

  static GlRenderer* instance;
  static GlFunctions ctx;
  SDL_GLContext sdl_gl_context;
  GlShader* current_shader = nullptr;
  const GlTexture* current_texture = nullptr;
  GlTexture* current_target = nullptr;
  GLBlendMode current_blend_mode =
    GLBlendMode{GL_ONE,GL_ONE,GL_ONE,GL_ONE,false};
  ShaderPtr main_shader;

  GLuint vao = 0;
  GLuint vbo = 0;
  GLuint ibo = 0;

  const GlTexture* test_texture = nullptr;

  Vertex* current_vertex = nullptr;
  size_t buffered_sprites = 0;
  size_t buffer_size = 0;
  std::vector<Vertex> vertex_buffer;

  Fbo screen_fbo = {0,glm::mat4()};
  std::unordered_map<uint_fast64_t,Fbo> fbos;
  Rectangle window_viewport;

  bool is_es_context;
};
}
