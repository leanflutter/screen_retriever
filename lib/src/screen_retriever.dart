// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'deprecation.dart';
import 'display.dart';
import 'screen_listener.dart';
import 'screen_retriever_platform.dart';

/// The 0.2.x `screenRetriever`, on top of nativeapi's `DisplayManager`.
@Deprecated(kLegacyDeprecation)
class ScreenRetriever {
  ScreenRetriever._();

  /// The shared instance of [ScreenRetriever].
  static final ScreenRetriever instance = ScreenRetriever._();

  ScreenRetrieverPlatform get _platform => ScreenRetrieverPlatform.instance;

  final ObserverList<ScreenListener> _listeners =
      ObserverList<ScreenListener>();
  StreamSubscription<Map<Object?, Object?>>? _subscription;

  void _handleScreenEvent(Map<Object?, Object?> event) {
    final type = event['type'];
    if (type is! String) return;
    for (final listener in List<ScreenListener>.of(_listeners)) {
      // A callback may have removed this listener during this notification.
      if (!_listeners.contains(listener)) continue;
      try {
        listener.onScreenEvent(type);
      } catch (error, stackTrace) {
        // Keep notifying the other listeners, as ChangeNotifier does.
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'screen_retriever',
            context: ErrorDescription('while notifying a ScreenListener'),
          ),
        );
      }
    }
  }

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(ScreenListener listener) {
    _listeners.add(listener);
    try {
      _subscription ??= _platform.onScreenEventReceiver.listen(
        _handleScreenEvent,
      );
    } catch (_) {
      // Do not keep a listener that will never be notified.
      _listeners.remove(listener);
      rethrow;
    }
  }

  void removeListener(ScreenListener listener) {
    _listeners.remove(listener);
    if (!hasListeners) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  /// The cursor position in logical pixels, from the top left of the
  /// primary display.
  Future<Offset> getCursorScreenPoint() {
    return _platform.getCursorScreenPoint();
  }

  Future<Display> getPrimaryDisplay() {
    return _platform.getPrimaryDisplay();
  }

  Future<List<Display>> getAllDisplays() async {
    return _platform.getAllDisplays();
  }
}

@Deprecated(kLegacyDeprecation)
final ScreenRetriever screenRetriever = ScreenRetriever.instance;
