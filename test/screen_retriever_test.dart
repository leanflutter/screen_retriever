import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_retriever/screen_retriever.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fakeDisplay = <String, dynamic>{
    'id': 0,
    'name': 'fakeDisplay',
    'size': {'width': 1920.0, 'height': 1080.0},
    'visiblePosition': {'x': 0.0, 'y': 0.0},
    'visibleSize': {'width': 1280.0, 'height': 720.0},
    'scaleFactor': 1,
  };
  final fakeCursorScreenPoint = <String, dynamic>{'x': 10.0, 'y': 10.0};

  group(ScreenRetriever, () {
    final screenRetriever = ScreenRetriever.instance;

    late MethodCall lastMethodCall;
    dynamic mockMethodCallReturnValue;

    Future<dynamic> handleMockMethodCall(MethodCall methodCall) async {
      lastMethodCall = methodCall;
      return mockMethodCallReturnValue;
    }

    setUp(() {
      screenRetriever.channel.setMockMethodCallHandler(handleMockMethodCall);
    });

    tearDown(() {
      screenRetriever.channel.setMockMethodCallHandler(null);
    });

    test('should correctly parse output when calling getCursorScreenPoint',
        () async {
      mockMethodCallReturnValue = fakeCursorScreenPoint;

      Offset resultData = await screenRetriever.getCursorScreenPoint();

      expect(lastMethodCall.method, 'getCursorScreenPoint');
      expect(resultData.dx, 10);
      expect(resultData.dy, 10);
    });

    test('should correctly parse output when calling getPrimaryDisplay',
        () async {
      mockMethodCallReturnValue = fakeDisplay;

      Display resultData = await screenRetriever.getPrimaryDisplay();

      expect(lastMethodCall.method, 'getPrimaryDisplay');
      expect(resultData.id, 0);
      expect(resultData.name, 'fakeDisplay');
      expect(resultData.size.width, 1920.0);
      expect(resultData.size.height, 1080.0);
      expect(resultData.visiblePosition!.dx, 0.0);
      expect(resultData.visiblePosition!.dy, 0.0);
      expect(resultData.visibleSize!.width, 1280.0);
      expect(resultData.visibleSize!.height, 720.0);
      expect(resultData.scaleFactor, 1);
    });

    test('should correctly parse output when calling getAllDisplays', () async {
      mockMethodCallReturnValue = {
        'displays': [fakeDisplay, fakeDisplay]
      };

      List<Display> resultData = await screenRetriever.getAllDisplays();

      expect(lastMethodCall.method, 'getAllDisplays');
      expect(resultData.length, 2);
      expect(resultData[0].id, 0);
      expect(resultData[0].name, 'fakeDisplay');
      expect(resultData[0].size.width, 1920.0);
      expect(resultData[0].size.height, 1080.0);
      expect(resultData[0].visiblePosition!.dx, 0.0);
      expect(resultData[0].visiblePosition!.dy, 0.0);
      expect(resultData[0].visibleSize!.width, 1280.0);
      expect(resultData[0].visibleSize!.height, 720.0);
      expect(resultData[0].scaleFactor, 1);
    });
  });
}
