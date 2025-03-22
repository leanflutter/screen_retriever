#pragma once

#include "screen_retriever.h"
#include <iostream>

// Windows implementation of ScreenRetriever
class ScreenRetrieverWindows : public ScreenRetriever {
 public:
  ScreenRetrieverWindows();
  ~ScreenRetrieverWindows() override;

  CursorPoint GetCursorScreenPoint() override;
  Display GetPrimaryDisplay() override;
  std::vector<Display> GetAllDisplays() override;
}; 