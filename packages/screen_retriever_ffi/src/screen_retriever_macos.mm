#include "screen_retriever_macos.h"
#include <cstring>
#include <iostream>
#include <string>

// Import Cocoa headers
#import <Cocoa/Cocoa.h>

// Helper function to convert NSString to char*
static char* ConvertNSStringToCString(NSString* nsString) {
  if (nsString == nil) {
    return strdup("");
  }
  const char* cString = [nsString UTF8String];
  return cString ? strdup(cString) : strdup("");
}

ScreenRetrieverMacOS::ScreenRetrieverMacOS() {
  // Constructor implementation
  std::cout << "ScreenRetrieverMacOS initialized" << std::endl;
}

ScreenRetrieverMacOS::~ScreenRetrieverMacOS() {
  // Destructor implementation
  std::cout << "ScreenRetrieverMacOS destroyed" << std::endl;
}

CursorPoint ScreenRetrieverMacOS::GetCursorScreenPoint() {
  CursorPoint point;

  // Get the current mouse position
  NSPoint mouseLocation = [NSEvent mouseLocation];
  point.x = mouseLocation.x;
  point.y = mouseLocation.y;

  return point;
}

Display ScreenRetrieverMacOS::GetPrimaryDisplay() {
  // Get the primary display (first screen)
  NSArray<NSScreen*>* screens = [NSScreen screens];
  return CreateDisplayFromNSScreen(screens[0], true);
}

DisplayList ScreenRetrieverMacOS::GetAllDisplays() {
  DisplayList displayList;

  // Get all screens
  NSArray<NSScreen*>* screens = [NSScreen screens];
  bool isFirstScreen = true;

  int count = (int) screens.count;
  displayList.displays = new Display[count];
  displayList.count = count;
  int index = 0;
  for (NSScreen* screen in screens) {
    displayList.displays[index] = CreateDisplayFromNSScreen(screen, isFirstScreen);
    index++;
    isFirstScreen = false;  // Only the first screen is the main screen
  }

  return displayList;
}

Display ScreenRetrieverMacOS::CreateDisplayFromNSScreen(NSScreen* screen, bool isFirstScreen) {
  Display display;

  // Get screen details
  NSRect frame = [screen frame];
  NSRect visibleFrame = [screen visibleFrame];
  CGFloat scaleFactor = [screen backingScaleFactor];

  // Set unique identifier for the screen using CGDirectDisplayID
  CGDirectDisplayID displayID =
      [[[screen deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue];
  NSString* screenId = [NSString stringWithFormat:@"%@", @(displayID)];
  display.id = ConvertNSStringToCString(screenId);

  // Set display name - use localizedName on macOS 10.15+
  NSString* displayName;
  if (@available(macOS 10.15, *)) {
    displayName = [screen localizedName];
  } else {
    displayName = isFirstScreen ? @"Primary Display"
                                : [NSString stringWithFormat:@"Display %@", @(displayID)];
  }
  display.name = ConvertNSStringToCString(displayName);

  // Set size and position properties
  display.width = frame.size.width;
  display.height = frame.size.height;
  display.visiblePositionX = visibleFrame.origin.x;
  display.visiblePositionY = visibleFrame.origin.y;
  display.visibleSizeWidth = visibleFrame.size.width;
  display.visibleSizeHeight = visibleFrame.size.height;
  display.scaleFactor = scaleFactor;

  return display;
}