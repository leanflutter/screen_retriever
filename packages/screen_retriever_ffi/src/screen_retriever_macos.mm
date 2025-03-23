#include "screen_retriever_macos.h"
#include <iostream>
#include <string>
#include <cstring>

// Force __OBJC__ to be defined if not already
#ifndef __OBJC__
#define __OBJC__ 1
#endif

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
  NSArray<NSScreen *>* screens = [NSScreen screens];
  return CreateDisplayFromNSScreen(screens[0], true);
}

std::vector<Display> ScreenRetrieverMacOS::GetAllDisplays() {
  std::vector<Display> displays;
  
  // Get all screens
  NSArray<NSScreen *>* screens = [NSScreen screens];
  bool isMainScreen = true;
  
  for (NSScreen* screen in screens) {
    displays.push_back(CreateDisplayFromNSScreen(screen, isMainScreen));
    isMainScreen = false;  // Only the first screen is the main screen
  }
  
  return displays;
}

Display ScreenRetrieverMacOS::CreateDisplayFromNSScreen(NSScreen* screen, bool isPrimary) {
  Display display;
  
  // Get screen details
  NSRect frame = [screen frame];
  NSRect visibleFrame = [screen visibleFrame];
  CGFloat scaleFactor = [screen backingScaleFactor];
  
  // Set unique identifier for the screen using CGDirectDisplayID
  CGDirectDisplayID displayID = [[[screen deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue];
  NSString* screenId = [NSString stringWithFormat:@"%@", @(displayID)];
  display.id = ConvertNSStringToCString(screenId);
  
  // Set display name - use localizedName on macOS 10.15+
  NSString* displayName;
  if (@available(macOS 10.15, *)) {
    displayName = [screen localizedName];
  } else {
    displayName = isPrimary ? @"Primary Display" : [NSString stringWithFormat:@"Display %@", @(displayID)];
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