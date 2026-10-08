# Quick Start

Follow the steps below to quickly get started with the `screen_retriever` plugin:

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  screen_retriever: ^0.3.0
```

Or

```yaml
dependencies:
  screen_retriever:
    git:
      url: https://github.com/leanflutter/screen_retriever.git
      ref: main
```

### Requirements

- Flutter 3.47 / Dart 3.13 or later, macOS 10.15 or later.
- Linux build machines need GTK 3, X11 and Xi development files.

```
sudo apt-get install libgtk-3-dev libx11-dev libxi-dev
```

## Usage

```dart
import 'package:screen_retriever/screen_retriever.dart';

final displayManager = DisplayManager.instance;

final primary = displayManager.getPrimary()!;
print('${primary.name}: ${primary.size.toSize()} at ${primary.scaleFactor}x');
print('work area: ${primary.workArea.toRect()}');

for (final display in displayManager.getAll()) {
  print('${display.id} ${display.name} at ${display.position.toOffset()}');
}

print('cursor: ${displayManager.getCursorPosition().toOffset()}');

final listenerId = displayManager.addListener((event) {
  switch (event) {
    case DisplayAddedEvent(:final display):
      print('added ${display.name}');
    case DisplayRemovedEvent(:final display):
      print('removed ${display.name}');
    case DisplayChangedEvent(:final display):
      print('changed ${display.name}');
  }
});
// Later: displayManager.removeListener(listenerId);
```

Positions and sizes are logical pixels, with the origin at the top left of the primary
display. nativeapi's `Point`, `Size` and `Rectangle` are not exported, because Flutter
has its own `Size`: `toOffset()`, `toSize()` and `toRect()` turn them into Flutter's.

> The [example app](./example) of this plugin covers the 0.2.x compatible API.

Coming from 0.2.x? The [README](https://github.com/leanflutter/screen_retriever#upgrading-from-02x) explains `package:screen_retriever/legacy.dart` and maps each old call to the native API.
