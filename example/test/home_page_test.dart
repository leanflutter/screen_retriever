// Exercises the sample UI with a fake display backend.
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_retriever/legacy.dart';
import 'package:screen_retriever_example/main.dart';

class _TestPlatform extends ScreenRetrieverPlatform {
  final events = StreamController<Map<Object?, Object?>>.broadcast();

  final displays = <Display>[
    const Display(id: '1', name: 'Primary screen', size: Size(1920, 1080)),
  ];

  Completer<Display>? pendingPrimary;
  bool fail = false;
  int primaryReads = 0;

  @override
  Stream<Map<Object?, Object?>> get onScreenEventReceiver => events.stream;

  @override
  Future<Offset> getCursorScreenPoint() async => Offset.zero;

  @override
  Future<Display> getPrimaryDisplay() {
    primaryReads++;
    if (fail) return Future.error(StateError('temporarily unavailable'));
    final completer = pendingPrimary;
    if (completer != null) return completer.future;
    return Future.value(displays.first);
  }

  @override
  Future<List<Display>> getAllDisplays() async => List.of(displays);
}

void main() {
  late _TestPlatform platform;

  setUp(() {
    platform = _TestPlatform();
    ScreenRetrieverPlatform.instance = platform;
  });

  tearDown(() async {
    await platform.events.close();
  });

  testWidgets('the example shows the primary display', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Primary screen'), findsWidgets);
    expect(platform.primaryReads, 1);
  });

  testWidgets('a monitor event refreshes the displays', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    platform.displays.add(
      const Display(id: '2', name: 'Second screen', size: Size(1280, 720)),
    );
    platform.events.add({'type': 'display-added'});
    await tester.pump();
    await tester.pump();

    expect(platform.primaryReads, 2);
    expect(find.text('Second screen'), findsOneWidget);

    // Let the event toast expire so no timer is left pending.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('ignores late results after disposal', (tester) async {
    platform.pendingPrimary = Completer<Display>();
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.pumpWidget(const SizedBox.shrink());
    platform.pendingPrimary!.complete(
      const Display(id: '1', size: Size(1920, 1080)),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('reports temporary display failures', (tester) async {
    platform.fail = true;
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('temporarily unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
