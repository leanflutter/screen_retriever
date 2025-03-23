#pragma once

#include <vector>

// Representation of a display
struct Display {
  char* id;
  char* name;
  double width;
  double height;
  double visiblePositionX;
  double visiblePositionY;
  double visibleSizeWidth;
  double visibleSizeHeight;
  double scaleFactor;
};

// Representation of a list of displays
struct DisplayList {
  Display* displays;
  int count;
};

// Representation of a cursor position
struct CursorPoint {
  double x;
  double y;
};

// Abstract base class for ScreenRetriever
class ScreenRetriever {
 public:
  virtual ~ScreenRetriever() = default;

  // Get the current cursor screen point
  virtual CursorPoint GetCursorScreenPoint() = 0;

  // Get the primary display information
  virtual Display GetPrimaryDisplay() = 0;

  // Get all displays information
  virtual DisplayList GetAllDisplays() = 0;
};
