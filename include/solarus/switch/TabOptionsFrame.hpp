#pragma once

#include <borealis.hpp>
#include <solarus/switch/Title.hpp>

using GameSettings = std::map<std::string, std::string>;

class TabOptionsFrame : public brls::TabFrame
{
  public:
  TabOptionsFrame(std::shared_ptr<GameSettings> const &, std::string & path, std::vector<Title> const & titles);

  private:
  std::vector<Title> titles_;
};
