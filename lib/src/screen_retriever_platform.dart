// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:ui';

import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:nativeapi_flutter/nativeapi_flutter.dart' show PointToOffset;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'deprecation.dart';
import 'display.dart';

/// What [ScreenRetriever] calls, kept so that tests can replace it.
@Deprecated(kLegacyDeprecation)
abstract class ScreenRetrieverPlatform extends PlatformInterface {
  ScreenRetrieverPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenRetrieverPlatform _instance = MethodChannelScreenRetriever();

  /// The default instance, [MethodChannelScreenRetriever].
  static ScreenRetrieverPlatform get instance => _instance;

  static set instance(ScreenRetrieverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Maps of the form `{'type': 'display-added'}`.
  Stream<Map<Object?, Object?>> get onScreenEventReceiver {
    throw UnimplementedError(
      'onScreenEventReceiver() has not been implemented.',
    );
  }

  Future<Offset> getCursorScreenPoint() {
    throw UnimplementedError(
      'getCursorScreenPoint() has not been implemented.',
    );
  }

  Future<Display> getPrimaryDisplay() {
    throw UnimplementedError('getPrimaryDisplay() has not been implemented.');
  }

  Future<List<Display>> getAllDisplays() async {
    throw UnimplementedError('getAllDisplays() has not been implemented.');
  }
}

/// The default [ScreenRetrieverPlatform]. It keeps its 0.2.x name, but no
/// method channel is left: it reads nativeapi's `DisplayManager`.
@Deprecated(kLegacyDeprecation)
class MethodChannelScreenRetriever extends ScreenRetrieverPlatform {
  nativeapi.ListenerId? _listenerId;

  late final StreamController<Map<Object?, Object?>> _events =
      StreamController<Map<Object?, Object?>>.broadcast(
        onListen: () {
          _listenerId = nativeapi.DisplayManager.instance.addListener(
            _onDisplayEvent,
          );
        },
        onCancel: () {
          final listenerId = _listenerId;
          _listenerId = null;
          if (listenerId != null) {
            nativeapi.DisplayManager.instance.removeListener(listenerId);
          }
        },
      );

  void _onDisplayEvent(nativeapi.DisplayEvent event) {
    final type = switch (event) {
      nativeapi.DisplayAddedEvent() => 'display-added',
      nativeapi.DisplayRemovedEvent() => 'display-removed',
      nativeapi.DisplayChangedEvent() => 'display-changed',
    };
    _events.add(<Object?, Object?>{'type': type});
  }

  @override
  Stream<Map<Object?, Object?>> get onScreenEventReceiver => _events.stream;

  @override
  Future<Offset> getCursorScreenPoint() async {
    return nativeapi.DisplayManager.instance.getCursorPosition().toOffset();
  }

  @override
  Future<Display> getPrimaryDisplay() async {
    final display = nativeapi.DisplayManager.instance.getPrimary();
    if (display == null) {
      throw Exception('Unable to get primary display.');
    }
    try {
      return displayFromNative(display);
    } finally {
      display.dispose();
    }
  }

  @override
  Future<List<Display>> getAllDisplays() async {
    final displays = nativeapi.DisplayManager.instance.getAll();
    try {
      if (displays.isEmpty) {
        throw Exception('Unable to get all displays.');
      }
      return displays.map(displayFromNative).toList();
    } finally {
      for (final display in displays) {
        display.dispose();
      }
    }
  }
}
