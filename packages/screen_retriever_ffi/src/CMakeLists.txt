# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(screen_retriever_ffi_library VERSION 0.0.1 LANGUAGES CXX)

add_library(screen_retriever_ffi SHARED
  "screen_retriever.cpp"
  "screen_retriever_ffi.cpp"
)

set_target_properties(screen_retriever_ffi PROPERTIES
  PUBLIC_HEADER "screen_retriever.h,screen_retriever_ffi.h;"
  OUTPUT_NAME "screen_retriever_ffi"
)

target_compile_definitions(screen_retriever_ffi PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(screen_retriever_ffi PRIVATE "-Wl,-z,max-page-size=16384")
endif()
