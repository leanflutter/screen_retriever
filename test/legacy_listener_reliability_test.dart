// Tests the deprecated listener bridge without loading the native library.
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_retriever/legacy.dart';

class _EventPlatform
    with MockPlatformInterfaceMixin
    implements ScreenRetrieverPlatform {
  final events = StreamController<Map<Object?, Object?>>.broadcast();

  @override
  Stream<Map<Object?, Object?>> get onScreenEventReceiver => events.stream;

  @override
  Future<Offset> getCursorScreenPoint() => throw UnimplementedError();

  @override
  Future<Display> getPrimaryDisplay() => throw UnimplementedError();

  @override
  Future<List<Display>> getAllDisplays() => throw UnimplementedError();
}

class _FailingPlatform extends _EventPlatform {
  @override
  Stream<Map<Object?, Object?>> get onScreenEventReceiver =>
      throw StateError('backend unavailable');
}

class _CallbackListener with ScreenListener {
  _CallbackListener(this.callback);

  final void Function(String) callback;

  @override
  void onScreenEvent(String eventName) => callback(eventName);
}

void main() {
  late _EventPlatform platform;
  late List<ScreenListener> registered;

  void register(ScreenListener listener) {
    registered.add(listener);
    screenRetriever.addListener(listener);
  }

  setUp(() {
    platform = _EventPlatform();
    ScreenRetrieverPlatform.instance = platform;
    registered = <ScreenListener>[];
  });

  tearDown(() async {
    for (final listener in registered) {
      screenRetriever.removeListener(listener);
    }
    // screenRetriever is a singleton: a leftover subscription would keep the
    // next test from subscribing to its own platform.
    expect(screenRetriever.hasListeners, isFalse);
    expect(platform.events.hasListener, isFalse);
    await platform.events.close();
  });

  test('a removed listener is skipped during the current event', () async {
    final firstReceived = <String>[];
    final received = <String>[];
    late _CallbackListener second;
    final first = _CallbackListener((event) {
      firstReceived.add(event);
      screenRetriever.removeListener(second);
    });
    second = _CallbackListener(received.add);

    register(first);
    register(second);
    platform.events.add({'type': 'display-removed'});
    await Future<void>.delayed(Duration.zero);

    expect(firstReceived, ['display-removed']);
    expect(received, isEmpty);
  });

  test('a throwing listener does not starve other listeners', () async {
    final errors = <FlutterErrorDetails>[];
    final previousHandler = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      final received = <String>[];
      register(_CallbackListener((_) => throw StateError('bad callback')));
      register(_CallbackListener(received.add));

      platform.events.add({'type': 'display-added'});
      await Future<void>.delayed(Duration.zero);

      expect(received, ['display-added']);
      expect(errors, hasLength(1));
      expect(errors.single.exception, isA<StateError>());
    } finally {
      FlutterError.onError = previousHandler;
    }
  });

  test('malformed event types are ignored', () async {
    final received = <String>[];
    register(_CallbackListener(received.add));

    platform.events.add({'type': 1});
    platform.events.add({'type': null});
    platform.events.add({'type': 'display-added'});
    await Future<void>.delayed(Duration.zero);

    expect(received, ['display-added']);
  });

  test('a failed subscription leaves no phantom listener', () {
    final listener = _CallbackListener((_) {});
    ScreenRetrieverPlatform.instance = _FailingPlatform();
    try {
      expect(() => screenRetriever.addListener(listener), throwsStateError);
      expect(screenRetriever.hasListeners, isFalse);
    } finally {
      ScreenRetrieverPlatform.instance = platform;
    }
  });
}
