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
    final type = event['type'] as String?;
    if (type == null) return;
    for (final listener in List<ScreenListener>.of(_listeners)) {
      listener.onScreenEvent(type);
    }
  }

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(ScreenListener listener) {
    _listeners.add(listener);
    _subscription ??= _platform.onScreenEventReceiver.listen(
      _handleScreenEvent,
    );
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
