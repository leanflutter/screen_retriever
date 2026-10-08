// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:ui';

import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:nativeapi_flutter/nativeapi_flutter.dart' show NativeSizeToSize;

import 'deprecation.dart';

/// A display as 0.2.x described it, in logical pixels.
///
/// The native API's `Display` (from `package:screen_retriever/screen_retriever.dart`)
/// reads its values live and has more of them: position, orientation, refresh
/// rate, bit depth and whether it is the primary display.
@Deprecated(kLegacyDeprecation)
class Display {
  const Display({
    required this.id,
    this.name,
    required this.size,
    this.visiblePosition,
    this.visibleSize,
    this.scaleFactor,
  });

  factory Display.fromJson(Map<String, dynamic> json) {
    return Display(
      id: json['id'] as String,
      name: json['name'] as String?,
      size: _sizeFromJson(json['size'])!,
      visiblePosition: _offsetFromJson(json['visiblePosition']),
      visibleSize: _sizeFromJson(json['visibleSize']),
      scaleFactor: json['scaleFactor'] as num?,
    );
  }

  /// The native display ID, as text.
  final String id;

  final String? name;

  final Size size;

  /// Where the work area starts: the display minus the menu bar, the taskbar
  /// or the panels.
  final Offset? visiblePosition;

  /// The size of the work area.
  final Size? visibleSize;

  final num? scaleFactor;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'size': _sizeToJson(size),
      'visiblePosition': visiblePosition == null
          ? null
          : {'dx': visiblePosition!.dx, 'dy': visiblePosition!.dy},
      'visibleSize': visibleSize == null ? null : _sizeToJson(visibleSize!),
      'scaleFactor': scaleFactor,
    };
  }
}

/// The 0.2.x shape of a native display. Not exported.
Display displayFromNative(nativeapi.Display display) {
  final workArea = display.workArea;
  return Display(
    id: '${display.id}',
    name: display.name,
    size: display.size.toSize(),
    visiblePosition: Offset(workArea.x, workArea.y),
    visibleSize: Size(workArea.width, workArea.height),
    scaleFactor: display.scaleFactor,
  );
}

Size? _sizeFromJson(Object? json) {
  if (json == null) return null;
  final map = (json as Map).cast<String, dynamic>();
  return Size(
    (map['width'] as num).toDouble(),
    (map['height'] as num).toDouble(),
  );
}

Offset? _offsetFromJson(Object? json) {
  if (json == null) return null;
  final map = (json as Map).cast<String, dynamic>();
  return Offset((map['dx'] as num).toDouble(), (map['dy'] as num).toDouble());
}

Map<String, dynamic> _sizeToJson(Size size) {
  return {'width': size.width, 'height': size.height};
}
