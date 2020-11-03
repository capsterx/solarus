#include "AboutTab.hpp"

AboutTab::AboutTab()
{ 
  auto label = std::make_unique<brls::Label>(brls::LabelStyle::REGULAR, "Switch Gui for Solarus Engine", false);
  this->addView(label.release());
}
  
brls::List::View * 
AboutTab::
getDefaultFocus()
{
  return nullptr;
}
