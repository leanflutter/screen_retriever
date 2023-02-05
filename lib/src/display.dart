import 'dart:ui';

/// Description of a user display screen.
class Display {
  // Unique identifier associated with the display.
  final num id;
  final String? name;
  final Size size;
  final Offset? visiblePosition;
  final Size? visibleSize;
  final num? scaleFactor;

  Display({
    required this.id,
    this.name,
    required this.size,
    this.visiblePosition,
    this.visibleSize,
    this.scaleFactor,
  });

  factory Display.fromJson(Map<String, dynamic> json) {
    Offset? visiblePosition;
    Size? visibleSize;

    if (json['visiblePosition'] != null) {
      visiblePosition = Offset(
        json['visiblePosition']['x'],
        json['visiblePosition']['y'],
      );
    }
    if (json['visibleSize'] != null) {
      visibleSize = Size(
        json['visibleSize']['width'],
        json['visibleSize']['height'],
      );
    }

    return Display(
      id: json['id'],
      name: json['name'],
      size: Size(
        json['size']['width'],
        json['size']['height'],
      ),
      visiblePosition: visiblePosition,
      visibleSize: visibleSize,
      scaleFactor: json.containsKey('scaleFactor') ? json['scaleFactor'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'visiblePosition': visiblePosition != null
          ? {
              'x': visiblePosition!.dx,
              'y': visiblePosition!.dy,
            }
          : null,
      'visibleSize': visibleSize != null
          ? {
              'width': visibleSize!.width,
              'height': visibleSize!.height,
            }
          : null,
      'scaleFactor': scaleFactor,
    };
  }
}
