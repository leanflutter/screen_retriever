#include "screen_retriever_macos.h"
#include <iostream>

ScreenRetrieverMacOS::ScreenRetrieverMacOS() {
  // Constructor implementation
  std::cout << "ScreenRetrieverMacOS initialized" << std::endl;
}

ScreenRetrieverMacOS::~ScreenRetrieverMacOS() {
  // Destructor implementation
  std::cout << "ScreenRetrieverMacOS destroyed" << std::endl;
}

CursorPoint ScreenRetrieverMacOS::GetCursorScreenPoint() {
  // Sample implementation returning a sample cursor position
  CursorPoint point;
  point.x = 500.0;
  point.y = 300.0;
  return point;
}

Display ScreenRetrieverMacOS::GetPrimaryDisplay() {
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

std::vector<Display> ScreenRetrieverMacOS::GetAllDisplays() {
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