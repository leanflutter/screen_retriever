import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_retriever/screen_retriever.dart';

class MockScreenRetrieverPlatform
    with MockPlatformInterfaceMixin
    implements ScreenRetrieverPlatform {
  @override
  Future<Offset> getCursorScreenPoint() {
    return Future(() => Offset.zero);
  }

  @override
  Future<List<Display>> getAllDisplays() {
    throw UnimplementedError();
  }

  @override
  Future<Display> getPrimaryDisplay() {
    throw UnimplementedError();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final ScreenRetrieverPlatform initialPlatform =
      ScreenRetrieverPlatform.instance;

  test('$MethodChannelScreenRetriever is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenRetriever>());
  });

  test('getCursorScreenPoint', () async {
    ScreenRetriever screenRetriever = ScreenRetriever.instance;
    MockScreenRetrieverPlatform fakePlatform = MockScreenRetrieverPlatform();
    ScreenRetrieverPlatform.instance = fakePlatform;

    expect(await screenRetriever.getCursorScreenPoint(), Offset.zero);
  });
}
