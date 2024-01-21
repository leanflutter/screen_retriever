import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_retriever_platform_interface/src/screen_retriever_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelScreenRetriever platform = MethodChannelScreenRetriever();
  const MethodChannel channel = MethodChannel('screen_retriever');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
