// Relative import to be able to reuse the C sources.
// See the comment in ../screen_retriever_ffi.podspec for more information.

// Make sure __OBJC__ is defined before including other files
#ifndef __OBJC__
#define __OBJC__ 1
#endif

// Import Cocoa framework
#import <Cocoa/Cocoa.h>

// Include source files
#include "../../src/screen_retriever_ffi.cpp"
#include "../../src/screen_retriever.cpp"
#include "../../src/screen_retriever_macos.mm"