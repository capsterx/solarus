#include <solarus/switch/TabOptionsFrame.hpp>
#include <solarus/switch/AboutTab.hpp>
#include <solarus/graphics/Video.h>
#include <solarus/graphics/SoftwareVideoMode.h>
#include <solarus/core/Arguments.h>
#include <solarus/core/Settings.h>
#include <solarus/core/QuestFiles.h>
#include <borealis/actions.hpp>
#include <cmath>
#include <switch.h>

namespace i18n = brls::i18n; // for loadTranslations() and getStr()
using namespace i18n::literals; // for _i18n

std::string get_keyboard_input(std::string default_str)
{
    SwkbdConfig kbd;
    unsigned int str_len = 256;
    if (R_SUCCEEDED(swkbdCreate(&kbd, 0)))
    {
        swkbdConfigMakePresetDefault(&kbd);
        swkbdConfigSetInitialText(&kbd, default_str.c_str());
        swkbdConfigSetStringLenMax(&kbd, str_len);
        //swkbdConfigSetHeaderText(&kbd, "Header Text");
        //swkbdConfigSetSubText(&kbd, "SubText");
        //swkbdConfigSetGuideText(&kbd, "Guide Text");
        char keyboard_chars[str_len];
        Result res = swkbdShow(&kbd, keyboard_chars, str_len);
        swkbdClose(&kbd);
        if (R_SUCCEEDED(res))
        {
            //std::cout << (std::string("kbd out: ") + keyboard_chars);
            std::string str = keyboard_chars;
            return str;
        }
    }
    return default_str;
}

class GameSelect :
  public brls::ListItem
{
public:
  GameSelect(Title const & title, std::string & path)
    : brls::ListItem(
        title.properties.get_title(),
        title.properties.get_short_description())
    , path_(path)
  {
    auto && title_str = title.properties.get_title();
    if (title_str.size() >= 33)
    {
      int text_size=22;
      if (title_str.size() > 42)
      {
        text_size = (int)((22.0 / (pow(pow((title_str.size()/43.0), (43.0 / title_str.size())), 2)-0.01)));
      }
      this->setTextSize(text_size);
      printf("Setting text size to : %lu - %d\n", title_str.size(), text_size);
    }
    if (title.properties.get_quest_version() != "")
    {
      this->setValue("v" + title.properties.get_quest_version());
    }
    this->setThumbnail((unsigned char *)title.icon.c_str(), title.icon.size());
    this->getClickEvent()->subscribe([path=title.path, this](auto v){
      this->path_ = path;
      printf("setting path to %s\n", path.c_str());
      brls::Application::quit();
    });
  }

private:
  std::string & path_;
};


class GameSetting : 
  public brls::ListItem
{
public:
  GameSetting(
    std::string const & name,
    std::string const & value,
    std::string const & argument,
    std::shared_ptr<GameSettings> const & setting)
  : brls::ListItem(name)
  , argument_(argument)
  , settings_(setting)
  {
    this->setValue(value);
    this->getClickEvent()->subscribe([this](auto v){ this->do_change(v);});
    this->update_args();
  }

  void do_change(View * v)
  {
    change(v);
    update_args();
  }

  virtual void change(View*)=0;
  virtual void update_args() {
    (*settings_)[this->argument_ + "="] = this->getValue();
  }

protected:
  std::string argument_;
  std::shared_ptr<GameSettings> settings_;
};

class YesNoSetting :
  public  GameSetting
{
public:
  using GameSetting::GameSetting;

private:
  void change(View *) override
  {
    if (this->getValue() == "no")
    {
      this->setValue("yes");
    }
    else
    {
      this->setValue("no");
    }
  }
};

class EnableSetting : public YesNoSetting
{
public:
  using YesNoSetting::YesNoSetting;

private:
  void update_args()
  {
    if (getValue() == "no")
    {
      (*settings_).erase(this->argument_);
    }
    else
    {
      (*settings_)[this->argument_] = "";
    }
  }
};

class KeyboardSetting 
: public GameSetting
{
public:
  using GameSetting::GameSetting;
 
private: 
  void change(View *) override
  {
    this->setValue(get_keyboard_input(this->getValue()));
  }

  void update_args()
  {
    if (getValue() == "")
    {
      (*settings_).erase(this->argument_);
    }
    else
    {
      GameSetting::update_args();
    }
  }
};
 
TabOptionsFrame::
TabOptionsFrame(
  std::shared_ptr<GameSettings> const & gs, std::string & path,
  std::vector<Title> const & titles)
  : TabFrame() 
{
  auto options_list = std::make_unique<brls::List>();
  std::vector<std::string> video_modes;
  {
    Solarus::Arguments args;
    args.add_argument("-no-video");
    Solarus::Video::initialize(args);
    Solarus::Video::set_quest_size_range(Solarus::Size(0, 0), Solarus::Size(0, 0), Solarus::Size(0, 0));
    for (auto && mode : Solarus::Video::get_video_modes())
    {
      video_modes.push_back(mode->get_name());
    }
  }
  Solarus::Video::quit();

  for (auto && title : titles) 
  {
    auto status_item = std::make_unique<GameSelect>(title, path);
    status_item->registerAction("brls/hints/options"_i18n, brls::Key::Y, [title, video_modes]() { 
      auto appView = std::make_unique<brls::AppletFrame>(true, true);
      if (!Solarus::QuestFiles::open_quest("", title.path))
      {
        printf("failed to open quest %s\n", title.path.c_str());
        return false;
      }

      const std::string file_name = "settings.dat";
      Solarus::Settings solarus_settings;
      if (Solarus::QuestFiles::data_file_exists(file_name) &&
          !Solarus::QuestFiles::data_file_is_dir(file_name)) {
        // First, load the existing settings.dat to preserve unmodified values.
        solarus_settings.load(file_name);
      }
      size_t default_video_mode = Solarus::Video::default_video_mode_index;
      {
        auto p = solarus_settings.get_string(Solarus::Settings::key_video_mode);
        if (p.second)
        {
          size_t i = 0;
          for (auto && video : video_modes)
          {
            if (p.first == video)
            {
              printf("Found default video mode: %lu\n", i);
              default_video_mode = i;
              break;
            }
            ++i;
          }
        }
      }
      

      auto settings_list = std::make_unique<brls::List>();
      {
        auto setting = std::make_unique<brls::SelectListItem>("video mode", video_modes, default_video_mode, "Software video mode");
        setting->getValueSelectedEvent()->subscribe([solarus_settings, video_modes, file_name](size_t i) mutable {
          solarus_settings.set_string(Solarus::Settings::key_video_mode, video_modes[i]);
          solarus_settings.save(file_name);
        });
        settings_list->addView(setting.release());
      }
      appView->setContentView(settings_list.release());
      

      //QVariant sound_volume = value("quest_sound_volume");
      //if (sound_volume.isValid()) {
      //  solarus_settings.set_integer(
      //        Solarus::Settings::key_sound_volume, sound_volume.toInt());
      //}       
      //
      //QVariant music_volume = value("quest_music_volume");
      //if (music_volume.isValid()) {
      //  solarus_settings.set_integer(
      //        Solarus::Settings::key_music_volume, music_volume.toInt());
      //}       
      //
      //QVariant language = value("quest_language");
      //if (language.isValid()) {
      //  solarus_settings.set_string(
      //        Solarus::Settings::key_language, language.toString().toStdString());
      //}       
      //
      //QVariant joypad_enabled = value("quest_joypad_enabled");
      //if (joypad_enabled.isValid()) {
      //  solarus_settings.set_boolean(
      //        Solarus::Settings::key_joypad_enabled, joypad_enabled.toBool());
      //}       
      
      brls::PopupFrame::open(
        title.properties.get_title(), 
	(unsigned char *)title.icon.c_str(),
	title.icon.size(),
	appView.release(),
	"Author: " + title.properties.get_author(),
        "Version: " + title.properties.get_quest_version());
      printf("returning...\n");

      return true; 
    });
    options_list->addView(status_item.release());
  }
  this->addTab("Games", options_list.release());


  auto settings_list = std::make_unique<brls::List>();
  {
    //auto setting = std::make_unique<brls::SelectListItem>("default video mode", video_modes, Solarus::Video::default_video_mode_index, "Default software rendering video mode.  For v1.5 games that do not allow it to be changed.  Not something the engine allows normally");
    //setting->getValueSelectedEvent()->subscribe([s=&*setting, video_modes](size_t i) {
    //  Solarus::Video::default_video_mode_index = i;
    //});
    //settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<YesNoSetting>("turbo", "no", "-turbo", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<EnableSetting>("audio disabled", "no", "-no-audio", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<KeyboardSetting>("quest_size", "400x240", "-quest-size", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<KeyboardSetting>("lag", "0", "-lag", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<YesNoSetting>("Enable lua console", "no", "-lua-console", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<EnableSetting>("force software rendering", "no", "-force-software-rendering", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<EnableSetting>("perf sound play", "no", "-perf-sound-play", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<KeyboardSetting>("quit combo", "", "-quit-combo", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<KeyboardSetting>("run lua script", "", "-s", gs);
    settings_list->addView(setting.release());
  }
  {
    auto setting = std::make_unique<KeyboardSetting>("joypad deadzone", "", "-s", gs);
    settings_list->addView(setting.release());
  }
  this->addTab("Settings", settings_list.release());
  this->addTab("About", new AboutTab());
}
