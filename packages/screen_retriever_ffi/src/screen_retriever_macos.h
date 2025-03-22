#pragma once

#include "screen_retriever.h"
#include <iostream>

// macOS implementation of ScreenRetriever
class ScreenRetrieverMacOS : public ScreenRetriever {
 public:
  ScreenRetrieverMacOS();
  ~ScreenRetrieverMacOS() override;

  CursorPoint GetCursorScreenPoint() override;
  Display GetPrimaryDisplay() override;
  std::vector<Display> GetAllDisplays() override;
}; 