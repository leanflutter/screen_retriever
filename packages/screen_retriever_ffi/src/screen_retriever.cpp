#include "screen_retriever.h"
#include <iostream>

// MacOSScreenRetriever implementation
MacOSScreenRetriever::MacOSScreenRetriever() {
  // Constructor implementation
  std::cout << "MacOSScreenRetriever initialized" << std::endl;
}

MacOSScreenRetriever::~MacOSScreenRetriever() {
  // Destructor implementation
  std::cout << "MacOSScreenRetriever destroyed" << std::endl;
}

CursorPoint MacOSScreenRetriever::GetCursorScreenPoint() {
  // Sample implementation returning a sample cursor position
  CursorPoint point;
  point.x = 500.0;
  point.y = 300.0;
  return point;
}

Display MacOSScreenRetriever::GetPrimaryDisplay() {
  // Sample implementation returning a sample primary display
  Display display;
  display.id = "display-1";
  display.name = "Built-in Retina Display";
  display.width = 2560.0;
  display.height = 1600.0;
  display.visiblePositionX = 0.0;
  display.visiblePositionY = 0.0;
  display.visibleWidth = 2560.0;
  display.visibleHeight = 1600.0;
  display.scaleFactor = 2.0;
  return display;
}

std::vector<Display> MacOSScreenRetriever::GetAllDisplays() {
  // Sample implementation returning a list of sample displays
  std::vector<Display> displays;

  // Primary display
  Display primaryDisplay = GetPrimaryDisplay();
  displays.push_back(primaryDisplay);

  // Sample external display
  Display externalDisplay;
  externalDisplay.id = "display-2";
  externalDisplay.name = "External Monitor";
  externalDisplay.width = 3840.0;
  externalDisplay.height = 2160.0;
  externalDisplay.visiblePositionX = 2560.0;
  externalDisplay.visiblePositionY = 0.0;
  externalDisplay.visibleWidth = 3840.0;
  externalDisplay.visibleHeight = 2160.0;
  externalDisplay.scaleFactor = 1.0;
  displays.push_back(externalDisplay);

  return displays;
}
