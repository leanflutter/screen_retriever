#include "screen_retriever_ffi.h"
#include <iostream>

// Include platform-specific implementations
#if defined(__APPLE__)
#include "screen_retriever_macos.h"
#elif defined(_WIN32)
#include "screen_retriever_windows.h"
#elif defined(__linux__)
#include "screen_retriever_linux.h"
#endif

// Global instance of ScreenRetriever
static ScreenRetriever* g_screen_retriever = nullptr;

// Initialize the appropriate screen retriever based on platform
void initialize_screen_retriever() {
  if (g_screen_retriever == nullptr) {
    #if defined(__APPLE__)
      g_screen_retriever = new ScreenRetrieverMacOS();
    #elif defined(_WIN32)
      g_screen_retriever = new ScreenRetrieverWindows();
    #elif defined(__linux__)
      g_screen_retriever = new ScreenRetrieverLinux();
    #else
      // Add other platform implementations as needed
      std::cerr << "Unsupported platform" << std::endl;
    #endif
  }
}

// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
FFI_PLUGIN_EXPORT int sum(int a, int b) {
  return a + b;
}

// A longer-lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
FFI_PLUGIN_EXPORT int sum_long_running(int a, int b) {
  // Simulate work.
#if _WIN32
  Sleep(5000);
#else
  usleep(5000 * 1000);
#endif
  return a + b;
}

FFI_PLUGIN_EXPORT struct Display get_primary_display() {
  initialize_screen_retriever();
  if (g_screen_retriever != nullptr) {
    // Get primary display information
    Display primaryDisplay = g_screen_retriever->GetPrimaryDisplay();
    std::cout << "Primary display: " << primaryDisplay.id << std::endl;
    std::cout << "Primary display: " << primaryDisplay.name << std::endl;
    std::cout << "Primary display: " << primaryDisplay.width << std::endl;
    std::cout << "Primary display: " << primaryDisplay.height << std::endl;
    std::cout << "Primary display: " << primaryDisplay.visiblePositionX << std::endl;
    std::cout << "Primary display: " << primaryDisplay.visiblePositionY << std::endl;
    std::cout << "Primary display: " << primaryDisplay.visibleWidth << std::endl;
    std::cout << "Primary display: " << primaryDisplay.visibleHeight << std::endl;
    // In a real implementation, you would convert this to a format that can be
    // passed back to Dart. For the sample, we just return success (1).
    return primaryDisplay;
  }
  return Display();
}

FFI_PLUGIN_EXPORT int get_all_displays() {
  initialize_screen_retriever();
  if (g_screen_retriever != nullptr) {
    // Get all displays information
    std::vector<Display> displays = g_screen_retriever->GetAllDisplays();
    // In a real implementation, you would convert this to a format that can be
    // passed back to Dart. For the sample, we just return the count of
    // displays.
    std::cout << "All displays: " << displays.size() << std::endl;
    return static_cast<int>(displays.size());
  }
  return 0;
}

// Get the current cursor position
FFI_PLUGIN_EXPORT int get_cursor_screen_point() {
  initialize_screen_retriever();
  if (g_screen_retriever != nullptr) {
    // Get cursor position
    CursorPoint cursorPoint = g_screen_retriever->GetCursorScreenPoint();
    std::cout << "Cursor position: " << cursorPoint.x << ", " << cursorPoint.y
              << std::endl;
    // In a real implementation, you would convert this to a format that can be
    // passed back to Dart. For the sample, we just return success (1).
    return 1;
  }
  return 0;
}