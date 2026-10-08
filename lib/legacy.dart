// ignore_for_file: deprecated_member_use_from_same_package

/// The `screen_retriever` API as it was before the move to nativeapi.
///
/// Existing apps keep working by importing this library instead of
/// `package:screen_retriever/screen_retriever.dart`. The changed import is
/// deliberate: this API is a bridge, its classes are deprecated, and it will be
/// removed in a future release. New code should use the native API exported
/// from `package:screen_retriever/screen_retriever.dart`.
library;

export 'src/display.dart' show Display;
export 'src/screen_listener.dart';
export 'src/screen_retriever.dart';
export 'src/screen_retriever_platform.dart';
