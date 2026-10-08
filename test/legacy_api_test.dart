// Guards the promise of package:screen_retriever/legacy.dart: code written for
// screen_retriever 0.2.x compiles unchanged. `_surface` names every public
// symbol of 0.2.2 with its old signature; it is compiled, never run, because
// running needs the native library. The tests below swap in a mock platform,
// as 0.2.x tests did.
// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_retriever/legacy.dart';

final _displayJson = <String, dynamic>{
  'id': '1',
  'name': 'Built-in Display',
  'size': {'width': 1920.0, 'height': 1080.0},
  'visiblePosition': {'dx': 0.0, 'dy': 25.0},
  'visibleSize': {'width': 1920.0, 'height': 1055.0},
  'scaleFactor': 2,
};

class _Mixed with ScreenListener {
  final List<String> events = <String>[];

  @override
  void onScreenEvent(String eventName) => events.add(eventName);
}

class _Implemented implements ScreenListener {
  @override
  void onScreenEvent(String eventName) {}
}

class _MockPlatform
    with MockPlatformInterfaceMixin
    implements ScreenRetrieverPlatform {
  final events = StreamController<Map<Object?, Object?>>.broadcast();

  @override
  Stream<Map<Object?, Object?>> get onScreenEventReceiver => events.stream;

  @override
  Future<Offset> getCursorScreenPoint() async => const Offset(10, 20);

  @override
  Future<Display> getPrimaryDisplay() async => Display.fromJson(_displayJson);

  @override
  Future<List<Display>> getAllDisplays() async => [
    Display.fromJson(_displayJson),
    Display.fromJson(_displayJson),
  ];
}

Future<void> _surface() async {
  final ScreenRetriever retriever = ScreenRetriever.instance;
  final bool hasListeners = screenRetriever.hasListeners;
  screenRetriever.addListener(_Mixed());
  screenRetriever.removeListener(_Implemented());
  final Offset point = await screenRetriever.getCursorScreenPoint();
  final Display primary = await screenRetriever.getPrimaryDisplay();
  final List<Display> all = await screenRetriever.getAllDisplays();
  final String id = primary.id;
  final String? name = primary.name;
  final Size size = primary.size;
  final Offset? visiblePosition = primary.visiblePosition;
  final Size? visibleSize = primary.visibleSize;
  final num? scaleFactor = primary.scaleFactor;
  final Map<String, dynamic> json = primary.toJson();
  const Display constructed = Display(id: '0', size: Size(1, 1));
  final ScreenRetrieverPlatform platform = ScreenRetrieverPlatform.instance;
  ScreenRetrieverPlatform.instance = MethodChannelScreenRetriever();
  final Stream<Map<Object?, Object?>> events = platform.onScreenEventReceiver;
}

void main() {
  late _MockPlatform platform;

  setUp(() {
    platform = _MockPlatform();
    ScreenRetrieverPlatform.instance = platform;
  });

  test('Display round-trips through JSON', () {
    final display = Display.fromJson(_displayJson);
    expect(display.id, '1');
    expect(display.size, const Size(1920, 1080));
    expect(display.visiblePosition, const Offset(0, 25));
    expect(display.visibleSize, const Size(1920, 1055));
    expect(Display.fromJson(display.toJson()).toJson(), display.toJson());
  });

  test('Display.fromJson takes integer coordinates', () {
    final display = Display.fromJson(<String, dynamic>{
      'id': '2',
      'size': {'width': 800, 'height': 600},
    });
    expect(display.size, const Size(800, 600));
    expect(display.visiblePosition, isNull);
  });

  test('screenRetriever asks the platform', () async {
    expect(await screenRetriever.getCursorScreenPoint(), const Offset(10, 20));
    expect(
      (await screenRetriever.getPrimaryDisplay()).name,
      'Built-in Display',
    );
    expect(await screenRetriever.getAllDisplays(), hasLength(2));
  });

  test('listeners get the event type, until they are removed', () async {
    final listener = _Mixed();
    screenRetriever.addListener(listener);
    expect(screenRetriever.hasListeners, isTrue);
    expect(platform.events.hasListener, isTrue);

    platform.events.add({'type': 'display-added'});
    platform.events.add({'other': 'ignored'});
    await Future<void>.delayed(Duration.zero);
    expect(listener.events, ['display-added']);

    screenRetriever.removeListener(listener);
    expect(screenRetriever.hasListeners, isFalse);
    expect(platform.events.hasListener, isFalse);
  });
}
