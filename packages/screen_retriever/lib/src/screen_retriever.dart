import 'package:flutter/widgets.dart';
import 'package:screen_retriever_platform_interface/screen_retriever_platform_interface.dart';

class ScreenRetriever {
  ScreenRetriever._();

  /// The shared instance of [ScreenRetriever].
  static final ScreenRetriever instance = ScreenRetriever._();

  ScreenRetrieverPlatform get _platform => ScreenRetrieverPlatform.instance;

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
