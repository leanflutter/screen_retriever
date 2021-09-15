import 'dart:ui';

class Display {
  // Unique identifier associated with the display.
  num id;
  String name;
  Size size;
  num? scaleFactor;

  Display({
    required this.id,
    required this.name,
    required this.size,
    this.scaleFactor,
  });

  factory Display.fromJson(Map<String, dynamic> json) {
    return Display(
      id: json['id'],
      name: json['name'],
      size: Size(
        json['size']['width'],
        json['size']['height'],
      ),
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
      'scaleFactor': scaleFactor,
    };
  }
}
