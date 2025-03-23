# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(screen_retriever_ffi_library VERSION 0.0.1 LANGUAGES CXX)

# Platform-specific source files
if (LINUX)
  set(PLATFORM_SOURCES "screen_retriever_linux.cpp")
elseif (APPLE)
  set(PLATFORM_SOURCES "screen_retriever_macos.mm")
elseif (WIN32)
  set(PLATFORM_SOURCES "screen_retriever_windows.cpp")
else()
  set(PLATFORM_SOURCES "")
endif()

add_library(screen_retriever_ffi SHARED
  "screen_retriever.cpp"
  "screen_retriever_ffi.cpp"
  ${PLATFORM_SOURCES}
)

set_target_properties(screen_retriever_ffi PROPERTIES
  PUBLIC_HEADER "screen_retriever.h;screen_retriever_ffi.h;screen_retriever_linux.h,screen_retriever_macos.h;screen_retriever_windows.h;"
  OUTPUT_NAME "screen_retriever_ffi"
)

target_compile_definitions(screen_retriever_ffi PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(screen_retriever_ffi PRIVATE "-Wl,-z,max-page-size=16384")
endif()
