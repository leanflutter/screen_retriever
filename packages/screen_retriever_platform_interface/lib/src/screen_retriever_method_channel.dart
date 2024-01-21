import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:screen_retriever_platform_interface/src/screen_retriever_platform.dart';

/// An implementation of [ScreenRetrieverPlatform] that uses method channels.
class MethodChannelScreenRetriever extends ScreenRetrieverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_retriever');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
