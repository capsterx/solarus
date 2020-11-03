#include <solarus/switch/TabOptionsFrame.hpp>
#include <switch.h>
#include <borealis.hpp>

namespace i18n = brls::i18n; // for loadTranslations() and getStr()
using namespace i18n::literals; // for _i18n

std::vector<std::string> switch_gui_main(int argc, char **argv)
{
  brls::Logger::setLogLevel(brls::LogLevel::DEBUG);
  
  i18n::loadTranslations();
  if (!brls::Application::init("main/name"_i18n))
  {
    brls::Logger::error("Unable to init Borealis application");
    return {};
  }
  auto settings = std::make_shared<GameSettings>();
  std::string path;
  brls::Application::pushView(new TabOptionsFrame(
   settings, 
   path,
   getTitles("sdmc:/switch/solarus/games")));
	
  while (brls::Application::mainLoop());
  printf("Leaving...\n");
  brls::Application::quit();
  std::vector<std::string> args;
  for (auto && kv : *settings)
  {
    args.push_back(kv.first + kv.second);
  }
  if (path != "")
  {
    args.push_back(path);
  }
  return args;
}
