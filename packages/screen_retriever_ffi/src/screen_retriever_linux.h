#pragma once

#include "screen_retriever.h"
#include <iostream>

// Linux implementation of ScreenRetriever
class ScreenRetrieverLinux : public ScreenRetriever {
 public:
  ScreenRetrieverLinux();
  ~ScreenRetrieverLinux() override;

  CursorPoint GetCursorScreenPoint() override;
  Display GetPrimaryDisplay() override;
  std::vector<Display> GetAllDisplays() override;
}; 