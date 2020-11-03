#pragma once

#include <string>
#include <vector>
#include <solarus/core/QuestProperties.h>

struct Title
{
  Solarus::QuestProperties properties; 
  std::string path;
  std::string icon;
};

std::vector<Title> getTitles(std::string const & path);
