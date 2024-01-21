#include <flutter_linux/flutter_linux.h>

#include "include/screen_retriever_linux/screen_retriever_linux_plugin.h"

// This file exposes some plugin internals for unit testing. See
// https://github.com/flutter/flutter/issues/88724 for current limitations
// in the unit-testable API.

FlMethodResponse* get_cursor_screen_point(ScreenRetrieverLinuxPlugin* self,
                                          FlValue* args);

FlMethodResponse* get_primary_display(ScreenRetrieverLinuxPlugin* self,
                                      FlValue* args);

FlMethodResponse* get_all_displays(ScreenRetrieverLinuxPlugin* self,
                                   FlValue* args);