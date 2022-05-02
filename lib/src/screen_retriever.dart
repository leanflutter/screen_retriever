import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:screen_retriever/screen_retriever.dart';

// import 'screen_listener.dart';

const kScreenEventDisplayAdded = 'display-added';
const kScreenEventDisplayRemoved = 'display-removed';

class ScreenRetriever {
  ScreenRetriever._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// The shared instance of [ScreenRetriever].
  static final ScreenRetriever instance = ScreenRetriever._();

  final MethodChannel _channel = const MethodChannel('screen_retriever');

  ObserverList<ScreenListener> _listeners = ObserverList<ScreenListener>();

  Future<void> _methodCallHandler(MethodCall call) async {
    final List<ScreenListener> localListeners =
        List<ScreenListener>.from(_listeners);
    for (final ScreenListener listener in localListeners) {
      if (!_listeners.contains(listener)) {
        return;
      }

      if (call.method != 'onEvent') throw UnimplementedError();

      String eventName = call.arguments['eventName'];
      listener.onScreenEvent(eventName);
    }
  }

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(ScreenListener listener) {
    _listeners.add(listener);
  }

  void removeListener(ScreenListener listener) {
    _listeners.remove(listener);
  }

  Future<Offset> getCursorScreenPoint() async {
    final Map<String, dynamic> arguments = {
      'devicePixelRatio': window.devicePixelRatio,
    };
    final Map<dynamic, dynamic> resultData =
        await _channel.invokeMethod('getCursorScreenPoint', arguments);
    return Offset(
      resultData['x'],
      resultData['y'],
    );
  }

  Future<Display> getPrimaryDisplay() async {
    final Map<String, dynamic> arguments = {
      'devicePixelRatio': window.devicePixelRatio,
    };
    final Map<dynamic, dynamic> resultData =
        await _channel.invokeMethod('getPrimaryDisplay', arguments);
    return Display.fromJson(Map<String, dynamic>.from(resultData));
  }

  Future<List<Display>> getAllDisplays() async {
    final Map<String, dynamic> arguments = {
      'devicePixelRatio': window.devicePixelRatio,
    };
    final Map<dynamic, dynamic> resultData =
        await _channel.invokeMethod('getAllDisplays', arguments);

    List<Display> displayList = [];

    if (resultData['displays'] != null) {
      displayList = (resultData['displays'] as List)
          .map((item) => Display.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return displayList;
  }
}

final screenRetriever = ScreenRetriever.instance;
