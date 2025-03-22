#include "screen_retriever_linux.h"
#include <iostream>

ScreenRetrieverLinux::ScreenRetrieverLinux() {
  // Constructor implementation
  std::cout << "ScreenRetrieverLinux initialized" << std::endl;
}

ScreenRetrieverLinux::~ScreenRetrieverLinux() {
  // Destructor implementation
  std::cout << "ScreenRetrieverLinux destroyed" << std::endl;
}

CursorPoint ScreenRetrieverLinux::GetCursorScreenPoint() {
  // Empty implementation 
  CursorPoint point;
  point.x = 0.0;
  point.y = 0.0;
  return point;
}

Display ScreenRetrieverLinux::GetPrimaryDisplay() {
  // Empty implementation
  Display display;
  display.id = "display-1";
  display.name = "Linux Display";
  display.width = 1920.0;
  display.height = 1080.0;
  display.visiblePositionX = 0.0;
  display.visiblePositionY = 0.0;
  display.visibleWidth = 1920.0;
  display.visibleHeight = 1080.0;
  display.scaleFactor = 1.0;
  return display;
}

std::vector<Display> ScreenRetrieverLinux::GetAllDisplays() {
  // Empty implementation
  std::vector<Display> displays;
  displays.push_back(GetPrimaryDisplay());
  return displays;
} 