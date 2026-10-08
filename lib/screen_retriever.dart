/// Displays and the cursor position, from nativeapi's `DisplayManager`.
///
/// Code written for screen_retriever 0.2.x imports
/// `package:screen_retriever/legacy.dart` instead.
///
/// nativeapi's `Point`, `Size` and `Rectangle` are not exported, as Flutter
/// has its own `Size`; convert with `toOffset()`, `toSize()` and `toRect()`.
library;

export 'package:nativeapi/nativeapi.dart'
    show
        Display,
        DisplayAddedEvent,
        DisplayChangedEvent,
        DisplayEvent,
        DisplayId,
        DisplayManager,
        DisplayOrientation,
        DisplayRemovedEvent,
        ListenerId;
export 'package:nativeapi_flutter/nativeapi_flutter.dart'
    show NativeSizeToSize, PointToOffset, RectangleToRect;
