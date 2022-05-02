import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:screen_retriever/screen_retriever.dart';

void main() {
  const MethodChannel channel = MethodChannel('screen_retriever');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
