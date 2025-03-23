#pragma once

#include "screen_retriever.h"
#include <iostream>

// Force __OBJC__ to be defined if not already
#ifndef __OBJC__
#define __OBJC__ 1
#endif

// Import Cocoa headers
#import <Cocoa/Cocoa.h>

// macOS implementation of ScreenRetriever
class ScreenRetrieverMacOS : public ScreenRetriever {
 public:
  ScreenRetrieverMacOS();
  ~ScreenRetrieverMacOS() override;

  CursorPoint GetCursorScreenPoint() override;
  Display GetPrimaryDisplay() override;
  std::vector<Display> GetAllDisplays() override;
  
 private:
  // Helper method to create Display struct from NSScreen
  Display CreateDisplayFromNSScreen(NSScreen* screen, bool isMainScreen);
}; 