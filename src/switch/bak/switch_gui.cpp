#include "solarus/core/QuestFiles.h"

#include <solarus/switch/switch_gui.hpp>
#include <filesystem>

#include "solarus/core/CurrentQuest.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/QuestProperties.h"


// Implement all the layout/application functions here

Solarus_GUI::Solarus_GUI() : Layout::Layout()
{
    auto dir = std::filesystem::path("sdmc:/switch/solarus/games");
    this->menu = pu::ui::elm::Menu::New(0, 156, 1280, pu::ui::Color::FromHex("#c7efd5"), 84, (506 / 84));
    this->Add(menu);
    printf("menu: %p\n", this->menu.get());
    this->menu->ClearItems();
    for(auto & p: std::filesystem::directory_iterator(dir))
    {
      printf("%s\n", p.path().string().c_str());
      if (Solarus::QuestFiles::open_quest("", p.path().string()))
      {
        //Solarus::CurrentQuest::set_language("en");
        auto info = Solarus::CurrentQuest::get_properties();
        auto ourEntry = pu::ui::elm::MenuItem::New(info.get_title());

        //QStringList file_names = {
        //        "logos/icon_16.png",
        //        "logos/icon_24.png",
        //        "logos/icon_32.png",
        //        "logos/icon_48.png",
        //        "logos/icon_64.png",
        //        "logos/icon_128.png",
        //        "logos/icon_256.png",
        //        "logos/icon_512.png",
        //        "logos/icon_1024.png",
        //};
        //for (const QString& file_name : file_names) {
        //  if (Solarus::QuestFiles::data_file_exists(file_name.toLocal8Bit().toStdString())) {
        //    std::string buffer = Solarus::QuestFiles::data_file_read(file_name.toLocal8Bit().toStdString());
        //    QPixmap pixmap;
        //    if (!pixmap.loadFromData((const uchar*) buffer.data(), (uint) buffer.size())) {
        //    }
        ourEntry->SetColor(pu::ui::Color::FromHex("#FFFFFFFF"));
        paths_.push_back(p.path().string());
        this->menu->AddItem(ourEntry);
      }
      else
      {
      	printf("not quest: %s\n", p.path().string().c_str());
      }
      Solarus::QuestFiles::close_quest();
    }
}


void 
Solarus_GUI::onInput(u64 Down, u64 Up, u64 Held, pu::ui::Touch Pos)
{
}

std::string
Solarus_GUI::get_path() const
{
	printf("index %d -- path: %s\n", this->menu->GetSelectedIndex(), paths_[this->menu->GetSelectedIndex()].c_str());
	return paths_[this->menu->GetSelectedIndex()];
}

std::string Solarus_GUI::selected_path_;

void MainApplication::OnLoad()
{
    // Create the layout (calling the smart constructor above)
    auto gui = Solarus_GUI::New();
    //printf("gui1 %p\n", gui.get());
    this->layout = gui;
    //printf("gui2 %p\n", gui.get());

    // Load the layout. In applications layouts are loaded, not added into a container (you don't select an added layout, just load it from this function)
    // Simply explained: loading layout = the application will render that layout in the very next frame
    this->LoadLayout(this->layout);
    this->SetOnInput([this, gui](u64 Down, u64 Up, u64 Held, pu::ui::Touch Pos) {
      if (Down & KEY_A)
      {
        //printf("%p\n", gui.get());
        Solarus_GUI::selected_path_ = gui->get_path();
        this->Close();
      }
      if (Down & KEY_B)
      {
        this->Close();
      }
      });

    // Set a function when input is caught. This input handling will be the first one to be handled (before Layout or any Elements)
    // Using a lambda function here to simplify things
    // You can use member functions via std::bind() C++ wrapper
//    this->SetOnInput([&](u64 Down, u64 Up, u64 Held, pu::ui::Touch Pos)
//    {
}
