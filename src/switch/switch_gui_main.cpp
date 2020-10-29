#include <solarus/switch/switch_gui.hpp>
#include <switch.h>

/*

// If you would like to initialize and finalize stuff before or after Plutonium, you can use libnx's userAppInit/userAppExit

extern "C" void userAppInit()
{
    // Initialize stuff
}

extern "C" void userAppExit()
{
    // Cleanup/finalize stuff
}

*/

// Main entrypoint
std::string switch_gui_main(int argc, char **argv)
{
    // First create our renderer, where one can customize SDL or other stuff's initialization.
  {
    auto renderer = pu::ui::render::Renderer::New(pu::ui::render::RendererInitOptions(SDL_INIT_EVERYTHING, pu::ui::render::RendererHardwareFlags).WithIMG(pu::ui::render::IMGAllFlags).WithMixer(pu::ui::render::MixerAllFlags).WithTTF());

      // Create our main application from the renderer
    auto main = MainApplication::New(renderer);

    // Prepare out application. This MUST be called or Show() will exit and nothing will be rendered.
    main->Prepare();

    // Show -> start rendering in an "infinite" loop
    // If wou would like to show with a "fade in" from black-screen to the UI, use instead ->ShowWithFadeIn();
    main->Show();
  }
  printf("selected path: %s\n", Solarus_GUI::selected_path_.c_str());
  return Solarus_GUI::selected_path_;

    // Exit homebrew (Plutonium will handle all disposing of UI and renderer/application, don't worry!
}
