import 'deprecation.dart';

/// Receives `display-added`, `display-removed` and `display-changed`.
@Deprecated(kLegacyDeprecation)
abstract mixin class ScreenListener {
  void onScreenEvent(String eventName) {}
}
