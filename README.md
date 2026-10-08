> **screen_retriever is built on [nativeapi](https://github.com/libnativeapi/nativeapi)**, a
> Flutter binding of one C++ core library ([libnativeapi/nativeapi](https://github.com/libnativeapi/nativeapi))
> shared by macOS, Windows and Linux. Coming from 0.2.x? See [Upgrading from 0.2.x](#upgrading-from-02x).

# screen_retriever

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url]

[pub-image]: https://img.shields.io/pub/v/screen_retriever.svg
[pub-url]: https://pub.dev/packages/screen_retriever
[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

This package lets Flutter desktop apps read the displays — their size, work area and
scale factor — and the cursor position, and hear when displays are added, removed or
changed.

English | [简体中文](./README-ZH.md)

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Platform Support](#platform-support)
- [Quick Start](#quick-start)
  - [Installation](#installation)
    - [Requirements](#requirements)
  - [Usage](#usage)
    - [Upgrading from 0.2.x](#upgrading-from-02x)
    - [Moving to the native API](#moving-to-the-native-api)
- [Who's using it?](#whos-using-it)
- [API](#api)
  - [Native API](#native-api)
- [Contributors ✨](#contributors-)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Platform Support

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|  ✔️   |  ✔️   |   ✔️    |

## Quick Start

### Installation

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

#### Requirements

- Flutter 3.47 / Dart 3.13 or later, macOS 10.15 or later.
- Linux build machines need GTK 3, X11 and Xi development files.

```
sudo apt-get install libgtk-3-dev libx11-dev libxi-dev
```

### Usage

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

#### Upgrading from 0.2.x

Code written for `screen_retriever` 0.2.x keeps working by importing
`package:screen_retriever/legacy.dart` instead of
`package:screen_retriever/screen_retriever.dart`. It provides the old `screenRetriever`,
`ScreenListener`, `Display` and `ScreenRetrieverPlatform` on top of the native API.

The import has to change on purpose: `legacy.dart` is a bridge, not the future of this
package. Its classes are marked `@Deprecated` and **will be removed in a later
release** — move to the native API above when you can.

```dart
import 'package:screen_retriever/legacy.dart';

final primaryDisplay = await screenRetriever.getPrimaryDisplay();
final displays = await screenRetriever.getAllDisplays();
final cursor = await screenRetriever.getCursorScreenPoint();
```

What differs from 0.2.x:

- Builds need Flutter 3.47 / Dart 3.13 and macOS 10.15 (0.2.x: Flutter 3.3). The
  `screen_retriever_platform_interface`, `_macos`, `_linux` and `_windows` packages
  are no longer used.
- `Display.id` is nativeapi's display ID as text. It stays the same while the display
  is connected, but not across launches or reconnects; 0.2.x used the platform's
  own ID on macOS and Windows and an empty string on Linux.
- `visiblePosition` and `visibleSize` are the work area — the display minus the
  menu bar, taskbar or panels — on every platform.
- Sizes are no longer rounded on Windows, so a 150 % display can report
  `1706.67` logical pixels.
- `ScreenListener` also hears `display-changed`, besides `display-added` and
  `display-removed`.
- `MethodChannelScreenRetriever` keeps its name and is still the default
  `ScreenRetrieverPlatform`, but no method channel is left: its `methodChannel` and
  `eventChannel` fields are gone. Tests that replace `ScreenRetrieverPlatform.instance`
  work as before.

#### Moving to the native API

| 0.2.x (`legacy.dart`) | Native API (`screen_retriever.dart`) |
| --- | --- |
| `await screenRetriever.getPrimaryDisplay()` | `DisplayManager.instance.getPrimary()` — synchronous, `null` when there is none |
| `await screenRetriever.getAllDisplays()` | `DisplayManager.instance.getAll()` |
| `await screenRetriever.getCursorScreenPoint()` | `DisplayManager.instance.getCursorPosition().toOffset()` |
| `display.id` (`String`) | `display.id` (`DisplayId`, an `int`) |
| `display.size` | `display.size.toSize()` |
| `display.visiblePosition`, `display.visibleSize` | `display.workArea.toRect()` |
| `display.name`, `display.scaleFactor` | the same, read live |
| — | `display.position`, `isPrimary`, `orientation`, `refreshRate`, `bitDepth` |
| `ScreenListener` with `screenRetriever.addListener` | `DisplayManager.instance.addListener((event) { ... })`, which returns the ID for `removeListener` |
| `onScreenEvent('display-added')`, `'display-removed'` | `DisplayAddedEvent`, `DisplayRemovedEvent`, `DisplayChangedEvent`, each with its `display` |
| `display.toJson()` | — a native `Display` reads its values live; copy the ones you need |

A native `Display` is a handle to the system's display: call `dispose()` when you are
done with one you got from `getAll()` or `getPrimary()`, or let it be garbage-collected.

## Who's using it?

- [Biyi (比译)](https://biyidev.com/) - A convenient translation and dictionary app.
- [FastForge](https://fastforge.dev/) - An efficient tool for rapid application development and prototyping.

## API

### Native API

`screen_retriever` re-exports the display APIs from `nativeapi`: `DisplayManager`,
`Display`, `DisplayEvent` and its subclasses, `DisplayId` and `DisplayOrientation`,
with the `toOffset()`, `toSize()` and `toRect()` conversions from `nativeapi_flutter`.
Import `package:screen_retriever/legacy.dart` only for code that still uses the 0.2.x
API.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lijy91"><img src="https://avatars.githubusercontent.com/u/3889523?v=4?s=100" width="100px;" alt="LiJianying"/><br /><sub><b>LiJianying</b></sub></a><br /><a href="https://github.com/leanflutter/screen_retriever/commits?author=lijy91" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ChristianEdwardPadilla"><img src="https://avatars.githubusercontent.com/u/37954976?v=4?s=100" width="100px;" alt="Christian Padilla"/><br /><sub><b>Christian Padilla</b></sub></a><br /><a href="https://github.com/leanflutter/screen_retriever/commits?author=ChristianEdwardPadilla" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jpnurmi"><img src="https://avatars.githubusercontent.com/u/140617?v=4?s=100" width="100px;" alt="J-P Nurmi"/><br /><sub><b>J-P Nurmi</b></sub></a><br /><a href="https://github.com/leanflutter/screen_retriever/commits?author=jpnurmi" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Kingtous"><img src="https://avatars.githubusercontent.com/u/39793325?v=4?s=100" width="100px;" alt="Kingtous"/><br /><sub><b>Kingtous</b></sub></a><br /><a href="https://github.com/leanflutter/screen_retriever/commits?author=Kingtous" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fufesou"><img src="https://avatars.githubusercontent.com/u/13586388?v=4?s=100" width="100px;" alt="fufesou"/><br /><sub><b>fufesou</b></sub></a><br /><a href="https://github.com/leanflutter/screen_retriever/commits?author=fufesou" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lukasz-lukasz-lukasz"><img src="https://avatars.githubusercontent.com/u/119860089?v=4?s=100" width="100px;" alt="lukasz-lukasz-lukasz"/><br /><sub><b>lukasz-lukasz-lukasz</b></sub></a><br /><a href="https://github.com/leanflutter/screen_retriever/commits?author=lukasz-lukasz-lukasz" title="Code">💻</a></td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td align="center" size="13px" colspan="7">
        <img src="https://raw.githubusercontent.com/all-contributors/all-contributors-cli/1b8533af435da9854653492b1327a23a4dbd0a10/assets/logo-small.svg">
          <a href="https://all-contributors.js.org/docs/en/bot/usage">Add your contributions</a>
        </img>
      </td>
    </tr>
  </tfoot>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## License

[MIT](./LICENSE)
