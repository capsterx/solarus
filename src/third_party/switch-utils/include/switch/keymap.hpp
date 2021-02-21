#pragma once
#include <iosfwd>
#include <memory>
#include <string>

union SDL_Event;

namespace nswitch {

class Switch_Key_Map
{
public:
   Switch_Key_Map(int screenx, int screeny);
   Switch_Key_Map();
   ~Switch_Key_Map();
   void load_file(std::ifstream &);
   void load_file(std::string const &);
   bool event(SDL_Event const &);
   void disable(bool);
   void screen(int x, int y);
   void mouse_movement(bool);
   void index(size_t);
private:
   class Key_Map_Impl;   
   std::unique_ptr<Key_Map_Impl> impl_;
};
}
