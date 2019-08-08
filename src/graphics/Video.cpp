/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/core/Arguments.h"
#include "solarus/core/CurrentQuest.h"
#include "solarus/core/Debug.h"
#include "solarus/core/Logger.h"
#include "solarus/core/PerfCounter.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/Rectangle.h"
#include "solarus/core/Size.h"
#include "solarus/graphics/Color.h"
#include "solarus/graphics/Hq2xFilter.h"
#include "solarus/graphics/Hq3xFilter.h"
#include "solarus/graphics/Hq4xFilter.h"
#include "solarus/graphics/Scale2xFilter.h"
#include "solarus/graphics/Shader.h"
#include "solarus/graphics/SoftwareVideoMode.h"
#include "solarus/graphics/Surface.h"
#include "solarus/graphics/Video.h"
#include "solarus/graphics/Renderer.h"
#include "solarus/graphics/sdlrenderer/SDLRenderer.h"
#include "solarus/graphics/glrenderer/GlRenderer.h"
#include <memory>
#include <sstream>
#include <utility>

#include <SDL.h>
#include <SDL_render.h>
#include <SDL_hints.h>

namespace Solarus {

namespace {

/**
 * \brief Wraps the current video context and settings.
 */
struct VideoContext {
  Video::Geometry geometry;                  // Sizes.
  std::vector<SoftwareVideoMode>
  all_video_modes;                      /**< Display information for each supported software video mode. */
  SDL_Window* main_window = nullptr;        /**< The window. */
  RendererPtr renderer = nullptr;           /**< The screen renderer. */
  SDL_PixelFormat* rgba_format = nullptr;   /**< The pixel color format to use. */

  // Legacy software video modes.

  const SoftwareVideoMode*
  video_mode = nullptr;                 /**< Current software video mode. */
  const SoftwareVideoMode*
  default_video_mode = nullptr;         /**< Default software video mode. */
  SurfacePtr scaled_surface = nullptr;      /**< The screen surface used with software-scaled modes. */
  SurfacePtr screen_surface = nullptr;      /**< Strange surface representing the window */
  ShaderPtr  current_shader = nullptr;      /**< Current fullscreen effect */

  std::string opengl_version = "none";
  std::string shading_language_version = "none";
  std::string opengl_vendor = "none";
  std::string opengl_renderer = "none";

  bool disable_window = false;              /**< Indicates that no window is displayed (used for unit tests). */
  bool fullscreen_window = false;           /**< True if the window is in fullscreen. */
  bool visible_cursor = true;               /**< True if the mouse cursor is visible. */
  bool pc_render = false;                   /**< Whether rendering performance counter is used. */
};

VideoContext context;

struct chain_end{};

template<typename T = chain_end>
RendererPtr renderer_chain(SDL_Window*, bool) {
  return nullptr;
}

template<typename T, typename ...Rest>
typename std::enable_if<!std::is_same<T,chain_end>::value,RendererPtr>::type
renderer_chain(SDL_Window* w, bool force_software) {
  auto p = T::create(w, force_software);
  if(p) return p;
  return renderer_chain<Rest...>(w, force_software);
}


template<typename ...T>
RendererPtr create_chain(SDL_Window* w, bool force_software) {
  return renderer_chain<T...,chain_end>(w, force_software);
}


/**
 * \brief Creates the window but does not show it.
 * \param args Command-line arguments.
 */
void create_window(const Arguments& args) {

  Debug::check_assertion(context.main_window == nullptr, "Window already exists");

  bool force_software = args.has_argument("-force-software-rendering");

  if(force_software) {
    Logger::info("Forcing software rendering : shaders will be unavailable");
  }

  std::string title = std::string("Solarus ") + SOLARUS_VERSION;
  context.main_window = SDL_CreateWindow(
        title.c_str(),
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        context.geometry.wanted_quest_size.width,
        context.geometry.wanted_quest_size.height,
        SDL_WINDOW_HIDDEN | SDL_WINDOW_RESIZABLE | (force_software ? 0 : SDL_WINDOW_OPENGL)
        );

  Debug::check_assertion(context.main_window != nullptr,
                         std::string("Cannot create the window: ") + SDL_GetError());

  context.renderer = create_chain<GlRenderer,SDLRenderer>(context.main_window, force_software);

  Debug::check_assertion(static_cast<bool>(context.renderer),
                         std::string("Cannot create the renderer: ") + SDL_GetError());

  Logger::info("Renderer: " + context.renderer->get_name());

  if(not force_software) {
    context.opengl_version = reinterpret_cast<const char*>(glGetString(GL_VERSION));
    context.shading_language_version = reinterpret_cast<const char *>(glGetString(GL_SHADING_LANGUAGE_VERSION));
    context.opengl_vendor = reinterpret_cast<const char*>(glGetString(GL_VENDOR));
    context.opengl_renderer = reinterpret_cast<const char*>(glGetString(GL_RENDERER));
  }

  Logger::info(std::string("OpenGL: ") + context.opengl_version);
  Logger::info(std::string("OpenGL vendor: ") + context.opengl_vendor);
  Logger::info(std::string("OpenGL renderer: ") + context.opengl_renderer);
  Logger::info(std::string("OpenGL shading language: ") + context.shading_language_version);
}

/**
 * \brief Creates the list of software video modes.
 */
void initialize_software_video_modes() {

  context.all_video_modes.emplace_back(
        "normal",
        context.geometry.quest_size * 2,
        nullptr
        );
  context.all_video_modes.emplace_back(
        "scale2x",
        context.geometry.quest_size * 2,
        std::unique_ptr<SoftwarePixelFilter>(new Scale2xFilter())
        );
  context.all_video_modes.emplace_back(
        "hq2x",
        context.geometry.quest_size * 2,
        std::unique_ptr<SoftwarePixelFilter>(new Hq2xFilter())
        );
  context.all_video_modes.emplace_back(
        "hq3x",
        context.geometry.quest_size * 3,
        std::unique_ptr<SoftwarePixelFilter>(new Hq3xFilter())
        );
  context.all_video_modes.emplace_back(
        "hq4x",
        context.geometry.quest_size * 4,
        std::unique_ptr<SoftwarePixelFilter>(new Hq4xFilter())
        );

  context.default_video_mode = &context.all_video_modes[0];

  // Everything is ready now.
  Video::set_default_video_mode();
}

}  // Anonymous namespace.

namespace Video {

/**
 * \brief Initializes the video system.
 *
 * This method should be called when the program starts.
 * Options recognized:
 *   -no-video
 *   -perf-video-render=yes|no
 *   -quest-size=WIDTHxHEIGHT
 *
 * \param args Command-line arguments.
 */
void initialize(const Arguments& args) {

  Debug::check_assertion(!is_initialized(), "Video system already initialized");

  // Show the SDL version.
  SDL_version sdl_version;
  SDL_GetVersion(&sdl_version);
  std::ostringstream oss;
  oss << "SDL: " << static_cast<int>(sdl_version.major) << "." << static_cast<int>(sdl_version.minor) << "." << static_cast<int>(sdl_version.patch);
  Logger::info(oss.str());



  // Check the -no-video, -perf-video-render and the -quest-size options.
  const std::string& quest_size_string = args.get_argument_value("-quest-size");
  context.disable_window = args.has_argument("-no-video");
  context.pc_render = args.get_argument_value("-perf-video-render") == "yes";

  context.geometry.wanted_quest_size = {
    SOLARUS_DEFAULT_QUEST_WIDTH,
    SOLARUS_DEFAULT_QUEST_HEIGHT
  };

  if (!quest_size_string.empty()) {
    if (!parse_size(quest_size_string, context.geometry.wanted_quest_size)) {
      Debug::error(std::string("Invalid quest size: '") + quest_size_string + "'");
    }
  }

  // Create a pixel format anyway to make surface and color operations work,
  context.rgba_format = SDL_AllocFormat(SDL_PIXELFORMAT_ABGR8888);

  if (context.disable_window) {
    context.renderer = SDLRenderer::create(nullptr, true); //Create window-less sdl renderer
  }else {
    create_window(args);
  }
}

/**
 * \brief Closes the video system.
 */
void quit() {

  if (!is_initialized()) {
    return;
  }

  if (is_fullscreen()) {
    // Get back on desktop before destroy the window.
    SDL_SetWindowFullscreen(context.main_window, 0);
  }

  context.all_video_modes.clear();

  if (context.rgba_format != nullptr) {
    SDL_FreeFormat(context.rgba_format);
    context.rgba_format = nullptr;
  }
  if (context.main_window != nullptr) {
    SDL_DestroyWindow(context.main_window);
    context.main_window = nullptr;
  }

  Surface::empty_cache();

  context = VideoContext();
}

/**
 * \brief Returns whether the video system is initialized.
 * \return \c true if video is initialized.
 */
bool is_initialized() {
  return context.video_mode != nullptr;
}

/**
 * \brief Returns the main window.
 * \return The main window, or nullptr if there is no window.
 */
SDL_Window* get_window() {
  return context.main_window;
}

/**
 * \brief Returns the main renderer.
 * \return The main renderer, or nullptr if there is no window.
 */
Renderer &get_renderer() {
  return *context.renderer;
}

/**
 * \brief Returns the pixel format to use.
 * \return The pixel format to use.
 */
SDL_PixelFormat* get_pixel_format() {
  return context.rgba_format;
}

/**
 * \brief Returns the OpenGL version name.
 * \return The OpenGL version name.
 */
const std::string& get_opengl_version() {
  return context.opengl_version;
}

/**
 * \brief Returns the shading language version.
 * \return The shading language version.
 */
const std::string& get_shading_language_version() {
  return context.shading_language_version;
}

/**
 * \brief Get the default rendering driver for the current platform.
 * \return a string containing the rendering driver name.
 */
std::string get_rendering_driver_name() {
  return context.renderer->get_name();
}

/**
 * \brief Shows the window if it is not disabled.
 */
void show_window() {
  if (!context.disable_window) {
    SDL_ShowWindow(context.main_window);
  }
}

/**
 * \brief Hides the window.
 */
void hide_window() {
  if (!context.disable_window) {
    SDL_HideWindow(context.main_window);
  }
}

/**
 * \brief Draws the quest surface on the screen with the current video mode.
 * \param quest_surface The quest surface to render on the screen.
 */
void render(const SurfacePtr& quest_surface) {
  if (context.pc_render) {
    PerfCounter::update("video-render");
  }

  if (context.disable_window) {
    return;
  }

  Debug::check_assertion(context.video_mode != nullptr,
                         "Missing video mode");

  // See if there is a filter to apply.
  SurfacePtr surface_to_render = quest_surface;
  const SoftwarePixelFilter* software_filter = context.video_mode->get_software_filter();
  if (software_filter != nullptr) {
    Debug::check_assertion(context.scaled_surface != nullptr,
                           "Missing destination surface for scaling");
    quest_surface->apply_pixel_filter(*software_filter, *context.scaled_surface);
    surface_to_render = context.scaled_surface;
  }

  bool final_draw_with_shader = false;

  if (context.current_shader != nullptr) {
    float scale_factor = context.current_shader->get_data().get_scaling_factor();
    //See if the shader must be draw to a intermediate surface
    if(scale_factor > 0.f) {
      context.current_shader->draw(
            *context.scaled_surface.get(),
            *quest_surface,
            DrawInfos(Rectangle(quest_surface->get_size()),
                      Point(),
                      Point(),
                      BlendMode::BLEND,
                      255,0,
                      Scale(scale_factor),
                      null_proxy /*dont care about this anyway*/));
      surface_to_render = context.scaled_surface;
    } else { //Shader can be draw directly
      final_draw_with_shader = true;
    }
  }

  const DrawProxy& proxy = final_draw_with_shader ?
        static_cast<const DrawProxy&>(*context.current_shader) :
        context.renderer->default_terminal();

  context.screen_surface->clear();
  proxy.draw(
        *context.screen_surface,
        *surface_to_render,
        DrawInfos(
          Rectangle(surface_to_render->get_size()),
          Point(),
          Point(),
          BlendMode::BLEND,
          255,0,
          get_output_size_no_bars()/surface_to_render->get_size(),
          null_proxy));
}

/**
 * @brief present the final result to the screen
 */
void finish() {
  context.renderer->present(context.main_window);
}

void invalidate(const SurfaceImpl& texture) {
  if(context.renderer) {
    context.renderer->invalidate(texture);
  }
}

SurfacePtr& get_screen_surface() {
  return context.screen_surface;
}

/**
 * \brief Gets the width and the height values from a size string of the form
 * "320x240".
 * \param size_string The input string.
 * \param size The resulting size. Unchanged in case of failure.
 * \return true in case of success, false if the string is not a valid size.
 */
bool parse_size(const std::string& size_string, Size& size) {

  size_t index = size_string.find('x');
  if (index == std::string::npos || index + 1 >= size_string.size()) {
    return false;
  }

  const std::string& width_string = size_string.substr(0, index);
  const std::string& height_string = size_string.substr(index + 1);

  int width = 0;
  int height = 0;
  std::istringstream iss(width_string);
  if (!(iss >> width) || width < 0) {
    return false;
  }

  iss.str(height_string);
  iss.clear();
  if (!(iss >> height) || height < 0) {
    return false;
  }

  size = { width, height };
  return true;
}

/**
 * \brief Returns the size of the quest surface to render on the screen.
 * \return The quest size.
 */
const Size& get_quest_size() {
  return context.geometry.quest_size;
}

/**
 * \brief Gets the allowed range of quest sizes for this quest.
 * \param normal_size Gets the default size for this quest.
 * \param min_size Gets the minimum size for this quest.
 * \param max_size Gets the maximum size for this quest.
 */
void get_quest_size_range(
    Size& normal_size,
    Size& min_size,
    Size& max_size) {

  normal_size = context.geometry.normal_quest_size;
  min_size = context.geometry.min_quest_size;
  max_size = context.geometry.max_quest_size;
}

/**
 * \brief Sets the allowed range of quest sizes for this quest.
 *
 * This function sets the actual quest size and finishes the initialization.
 *
 * \param normal_size Default size for this quest.
 * \param min_size Minimum size for this quest.
 * \param max_size Maximum size for this quest.
 */
void set_quest_size_range(
    const Size& normal_size,
    const Size& min_size,
    const Size& max_size) {

  Debug::check_assertion(
        normal_size.width >= min_size.width
        && normal_size.height >= min_size.height
        && normal_size.width <= max_size.width
        && normal_size.height <= max_size.height,
        "Invalid quest size range");

  context.geometry.normal_quest_size = normal_size;
  context.geometry.min_quest_size = min_size;
  context.geometry.max_quest_size = max_size;

  if (context.geometry.wanted_quest_size.width < min_size.width
      || context.geometry.wanted_quest_size.height < min_size.height
      || context.geometry.wanted_quest_size.width > max_size.width
      || context.geometry.wanted_quest_size.height > max_size.height) {
    // The wanted size is not in the range supported by this quest.
    context.geometry.quest_size = normal_size;
  }
  else {
    context.geometry.quest_size = context.geometry.wanted_quest_size;
  }

  // We know the quest size: we can initialize legacy video modes.
  initialize_software_video_modes();

  // Initialize the screen surface with an initial window resized event.
  if (!context.disable_window) {
    on_window_resized(get_window_size());
  }
}

/**
 * \brief Returns whether the current video mode is in fullscreen.
 * \return true if the current video mode is in fullscreen.
 */
bool is_fullscreen() {
  return context.fullscreen_window;
}

/**
 * \brief Sets the video mode to fullscreen or windowed,
 * keeping an equivalent resolution.
 * \param fullscreen true to make fullscreen.
 */
void set_fullscreen(bool fullscreen) {

  if (context.main_window == nullptr) {
    return;
  }

  if (context.fullscreen_window != fullscreen) {
    Uint32 fullscreen_flag;
    if (fullscreen) {
      fullscreen_flag = SDL_WINDOW_FULLSCREEN_DESKTOP;
      context.geometry.window_size = get_window_size();  // Store the window size before fullscreen.
    }
    else {
      fullscreen_flag = 0;
    }
    context.fullscreen_window = fullscreen;

    SDL_SetWindowFullscreen(context.main_window, fullscreen_flag);
    if (not fullscreen && not context.geometry.window_size.is_flat()) {
      // Do window resized event after coming back from fullscreen
      on_window_resized(context.geometry.window_size);
    }
  }

  Logger::info(std::string("Fullscreen: ") + (fullscreen ? "yes" : "no"));
}

/**
 * \brief Returns whether the mouse cursor is currently visible.
 * \return true if the mouse cursor is currently visible.
 */
bool is_cursor_visible() {
  return context.visible_cursor;
}

/**
 * \brief Sets the mouse cursor to visible or invisible.
 * \param cursor_visible true to make the cursor visible.
 */
void set_cursor_visible(bool cursor_visible) {

  context.visible_cursor = cursor_visible;
  SDL_ShowCursor(context.visible_cursor);
  Logger::info(std::string("Cursor visible: ") + (cursor_visible ? "yes" : "no"));
}

/**
 * \brief Returns the current shader applied to the rendering if any.
 * \return The current shader or nullptr.
 */
const ShaderPtr& get_shader() {
  return context.current_shader;
}

/**
 * \brief Sets the current shader to the rendering.
 * \param shader The shader to apply or nullptr.
 */
void set_shader(const ShaderPtr& shader) {
  context.current_shader = shader;

  if (shader != nullptr) {
    float s = shader->get_data().get_scaling_factor();
    if (s > 0.f) { // Create scaled surface if needed
      context.scaled_surface = Surface::create(Video::get_quest_size() * Scale(s));
    }
    if (!shader->get_id().empty()) {
      Logger::info("Shader: '" + shader->get_id() + "'");
    }
    else {
      Logger::info("Shader: active");
    }
  }
  else {
    Logger::info("Shader: none");
  }
}

/**
 * \brief Returns the current text of the window title bar.
 * \return The window title.
 */
std::string get_window_title() {

  return SDL_GetWindowTitle(context.main_window);
}

/**
 * \brief Sets the text of the window title bar.
 * \param window_title The window title to set.
 */
void set_window_title(const std::string& window_title) {

  SDL_SetWindowTitle(context.main_window, window_title.c_str());
}

/**
 * @brief set_window_icon
 * @param icon, the surface containing the icon, ownership is not taken, surface can be freed after the call
 */
void set_window_icon(SDL_Surface* icon) {
  if (context.main_window) {
    SDL_SetWindowIcon(context.main_window, icon);
  }
}

/**
 * \brief Returns whether a video mode is supported.
 * \param mode a video mode
 * \return true if this mode is supported
 */
bool is_mode_supported(const SoftwareVideoMode& mode) {

  for (const SoftwareVideoMode& current_mode: context.all_video_modes) {
    if (current_mode.get_name() == mode.get_name()) {
      return true;
    }
  }

  // The initial detection of this mode failed.
  return false;
}

/**
 * \brief Sets the default video mode.
 */
void set_default_video_mode() {

  Debug::check_assertion(context.default_video_mode != nullptr,
                         "Default video mode was not initialized");

  set_fullscreen(false);
  set_video_mode(*context.default_video_mode);
}

/**
 * \brief Sets the next video mode.
 *
 * The fullscreen flag is preserved.
 * The window size is reset to the default size of the new video mode.
 */
void switch_video_mode() {

  if (context.all_video_modes.size() <= 1) {
    return;
  }

  // Find the current video mode in the list and traverse the list from there.
  std::vector<SoftwareVideoMode>::const_iterator it;
  for (it = context.all_video_modes.begin(); it != context.all_video_modes.end(); ++it) {
    if (it->get_name() == context.video_mode->get_name()) {
      break;
    }
  };

  const SoftwareVideoMode* mode = nullptr;
  do {
    if (it != context.all_video_modes.end()) {
      ++it;
    }
    if (it == context.all_video_modes.end()) {
      it = context.all_video_modes.begin();
    }
    mode = &(*it);
  } while (mode == nullptr || !is_mode_supported(*mode));

  set_video_mode(*mode);
}

/**
 * \brief Sets the software video mode.
 *
 * The fullscreen setting is unchanged.
 * If the mode changes, the window size is reset to its default value.
 *
 * \param mode The video mode to set.
 * \param fullscreen \c true to set the window to fullscreen.
 * \return true in case of success, false if this mode is not supported.
 */
bool set_video_mode(const SoftwareVideoMode& mode) {

  bool mode_changed = context.video_mode == nullptr
      || mode.get_name() != context.video_mode->get_name();

  if (!is_mode_supported(mode)) {
    return false;
  }

  context.video_mode = &mode;
  if (!context.disable_window) {

    context.scaled_surface = nullptr;

    Size render_size = context.geometry.quest_size;

    const SoftwarePixelFilter* software_filter = mode.get_software_filter();
    if (software_filter != nullptr) {
      int factor = software_filter->get_scaling_factor();
      render_size = context.geometry.quest_size * factor;
      context.scaled_surface = Surface::create(render_size);
      context.scaled_surface->fill_with_color(Color::black);  // To initialize the internal surface.
    }

    if (mode_changed) {
      reset_window_size();
    }
  }

  return true;
}

/**
 * \brief Returns the current video mode.
 * \return The video mode.
 */
const SoftwareVideoMode& get_video_mode() {

  Debug::check_assertion(context.video_mode != nullptr,
                         "Video mode not initialized");
  return *context.video_mode;
}

/**
 * \brief Returns a list of all supported video modes.
 * \return The list of supported video modes.
 */
std::vector<const SoftwareVideoMode*> get_video_modes() {

  // Return a copy of all_video_modes with const elements.
  std::vector<const SoftwareVideoMode*> result;
  for (const SoftwareVideoMode& video_mode: context.all_video_modes) {
    result.push_back(&video_mode);
  }
  return result;
}

/**
 * \brief Returns a video mode given its Lua name.
 * \param mode_name Lua name of a video mode.
 * \return The corresponding supported video mode, or nullptr if there is no
 * known supported video mode with this name.
 */
const SoftwareVideoMode* get_video_mode_by_name(
    const std::string& mode_name) {

  for (const SoftwareVideoMode& video_mode: context.all_video_modes) {
    if (video_mode.get_name() == mode_name) {
      return &video_mode;
    }
  }

  return nullptr;
}

/**
 * \brief Returns the size of the window.
 *
 * This includes letterboxing black bars if any.
 * It does not include the window decorations if any.
 *
 * In fullscreen mode, returns the size the window would have in windowed mode.
 *
 * \return The size of the window in pixels.
 */
Size get_window_size() {
  Debug::check_assertion(context.main_window != nullptr, "No window");

  if (is_fullscreen()) {
    // Returns the memorized window size.
    return context.geometry.window_size;
  }

  // Returns the current window size.
  int width = 0;
  int height = 0;
  SDL_GetWindowSize(context.main_window, &width, &height);

  return { width, height };
}

/**
 * \brief Sets the size of the window.
 *
 * Letterboxing black bars will be included if necessary to keep the quest aspect ratio.
 * It does not include the window decorations if any.
 *
 * In fullscreen mode, sets the size the window should have in windowed mode.
 *
 * \param size The size of the window in pixels.
 */
void set_window_size(const Size& size) {

  Debug::check_assertion(context.main_window != nullptr, "No window");
  Debug::check_assertion(
        size.width > 0 && size.height > 0,
        "Wrong window size"
        );

  if (is_fullscreen()) {
    // Store the size to remember it during fullscreen.
    context.geometry.window_size = size;
  }
  else {
    int width = 0;
    int height = 0;
    SDL_GetWindowSize(context.main_window, &width, &height);
    if (width != size.width || height != size.height) {
      SDL_SetWindowSize(
            context.main_window,
            size.width,
            size.height
            );
      on_window_resized(size);
      SDL_SetWindowPosition(
            context.main_window,
            SDL_WINDOWPOS_CENTERED,
            SDL_WINDOWPOS_CENTERED
            );
    }
  }
}

/**
 * \brief Restores the default size of the window for the current video mode.
 */
void reset_window_size() {

  Debug::check_assertion(context.video_mode != nullptr, "No video mode");

  set_window_size(context.video_mode->get_initial_window_size());
}

/**
 * @brief return a letter boxed size
 * @param basesize window base size
 * @return
 */
Rectangle get_letter_box(const Size& basesize) {
  float qratio = context.geometry.quest_size.width / static_cast<float>(context.geometry.quest_size.height);
  float wratio = basesize.width / static_cast<float>(basesize.height);
  if(qratio > wratio) {
    return {
      0,
      static_cast<int>(basesize.height-basesize.width/qratio)/2,
          basesize.width,
          static_cast<int>(basesize.width/qratio)};
  } else {
    return {
      static_cast<int>(basesize.width-basesize.height*qratio)/2,
          0,
          static_cast<int>(basesize.height*qratio),
          basesize.height};
  }
}

/**
 * @brief Window resize event
 * @param size new window size
 */
void on_window_resized(const Size& size) {
  Rectangle letter = get_letter_box(size);
  context.renderer->on_window_size_changed(letter);
  SurfaceImplPtr surface_impl = context.renderer->create_window_surface(context.main_window,letter.get_width(),letter.get_height());
  context.screen_surface = Surface::create(surface_impl);
  context.geometry.logical_size = letter.get_size();
}

/**
 * \brief Returns the output size of the renderer.
 *
 * This includes letterboxing black bars.
 * Unlike get_window_size(), this function takes care
 * of whether fullscreen is active.
 *
 * \return The output size of the renderer in pixels.
 */
Size get_output_size() {

  Debug::check_assertion(context.main_window != nullptr, "No window");

  int width = 0;
  int height = 0;
  SDL_GetWindowSize(context.main_window, &width, &height);

  return { width, height };
}

/**
 * \brief Returns the output size of the renderer.
 *
 * This does not include letterboxing black bars.
 * Unlike get_window_size(), this function takes care
 * of whether fullscreen is active.
 *
 * \return The output size of the renderer in pixels,
 * not including black bars.
 */
Size get_output_size_no_bars() {
  return context.geometry.logical_size;
}

/**
 * \brief Converts renderer output coordinates to quest size coordinates.
 * \param output_xy A position relative to the renderer output, not including
 * window decorations.
 * \return The position in quest size coordinate.
 */
Point output_to_quest_coordinates(const Point& output_xy) {

  Rectangle viewport = get_letter_box(get_output_size());
  Size qs = get_quest_size();

  float scale_x = viewport.get_width() / static_cast<float>(qs.width);
  float scale_y = viewport.get_height() / static_cast<float>(qs.height);

  const int x = (output_xy.x - viewport.get_x())/scale_x;
  const int y = (output_xy.y - viewport.get_y())/scale_y;

  Debug::check_assertion(!qs.is_flat(), "Quest size is not initialized");
  Debug::check_assertion(!viewport.is_flat(), "Viewport is not initialized");

  return {x,y};
}

/**
 * \brief Converts logical renderer coordinates to quest size coordinates.
 * \param[in] renderer_xy A position in renderer coordinates, without window scaling.
 * \return The corresponding value in quest coordinates.
 */
Point renderer_to_quest_coordinates(
    const Point& renderer_xy
    ) {
  return renderer_xy; //TODO check if this is true now
}

}  // namespace Video

}  // namespace Solarus
