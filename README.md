> **🚀 Ship Your App Faster**: Try [Fastforge](https://fastforge.dev) - The simplest way to build, package and distribute your Flutter apps.

# screen_retriever

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url]

[pub-image]: https://img.shields.io/pub/v/screen_retriever.svg
[pub-url]: https://pub.dev/packages/screen_retriever
[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

This plugin allows Flutter desktop apps to Retrieve information about screen size, displays, cursor position, etc.

---

## 🚀 Check out FastForge

**[FastForge](https://fastforge.dev/)** - A powerful tool for accelerating Flutter development.
Build beautiful, responsive applications with ease. Try it today!

---

English | [简体中文](./README-ZH.md)

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Platform Support](#platform-support)
- [Quick Start](#quick-start)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Listening events](#listening-events)
- [Who's using it?](#whos-using-it)
- [API](#api)
  - [ScreenRetriever](#screenretriever)
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
  screen_retriever: ^0.2.0
```

Or

```yaml
dependencies:
  screen_retriever:
    git:
      url: https://github.com/leanflutter/screen_retriever.git
      path: packages/screen_retriever
      ref: main
```

### Usage

```dart
Display? _primaryDisplay;
List<Display> _displayList = [];

void _init() async {
  _primaryDisplay = await screenRetriever.getPrimaryDisplay();
  _displayList = await screenRetriever.getAllDisplays();
  setState(() {});
}
```

### Listening events

```dart
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScreenListener {
  @override
  void initState() {
    screenRetriever.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    screenRetriever.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ...
  }

  @override
  void onScreenEvent(String eventName) {
    String log = 'Event received: $eventName)';
    print(log);
  }
}
```

> Please see the example app of this plugin for a full example.

## Who's using it?

- [Biyi (比译)](https://biyidev.com/) - A convenient translation and dictionary app.
- [FastForge](https://fastforge.dev/) - An efficient tool for rapid application development and prototyping.

## API

### ScreenRetriever

| Method                 | Description                                                                  | Linux | macOS | Windows |
| ---------------------- | ---------------------------------------------------------------------------- | ----- | ----- | ------- |
| `getCursorScreenPoint` | Returns `Offset` - The current absolute position of the mouse pointer.       | ✔️    | ✔️    | ✔️      |
| `getPrimaryDisplay`    | Returns `Display` - The primary display.                                     | ✔️    | ✔️    | ✔️      |
| `getAllDisplays`       | Returns `List<Display>` - An array of displays that are currently available. | ✔️    | ✔️    | ✔️      |

## License

[MIT](./LICENSE)
