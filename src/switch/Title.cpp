#include <filesystem>
#include <solarus/switch/Title.hpp>
#include <solarus/core/CurrentQuest.h>
#include <solarus/core/QuestFiles.h>
#include <solarus/core/QuestProperties.h>

std::vector<Title> getTitles(std::string const & path)
{
  auto dir = std::filesystem::path(path);
  std::vector<Title> titles;
  for(auto & p: std::filesystem::directory_iterator(dir))
  {
    auto title = Title();
    title.path = p.path().string();
    if (Solarus::QuestFiles::open_quest("", title.path))
    {
      title.properties = Solarus::CurrentQuest::get_properties();
      std::vector<std::string> file_names = {
              "logos/icon_16.png",
              "logos/icon_24.png",
              "logos/icon_32.png",
              "logos/icon_48.png",
              "logos/icon_64.png",
              "logos/icon_128.png",
              "logos/icon_256.png",
              "logos/icon_512.png",
              "logos/icon_1024.png",
      };
      for (auto && file_name : file_names) 
      {
        if (Solarus::QuestFiles::data_file_exists(file_name))
        {
          title.icon = Solarus::QuestFiles::data_file_read(file_name);
          break;
        }
      }
      titles.push_back(title);
    }
  }
  return titles;
}
