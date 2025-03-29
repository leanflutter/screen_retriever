> **🚀 Ship Your App Faster**: Try [Fastforge](https://fastforge.dev) - The simplest way to build, package and distribute your Flutter apps.

# screen_retriever

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url]

[pub-image]: https://img.shields.io/pub/v/screen_retriever.svg
[pub-url]: https://pub.dev/packages/screen_retriever
[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

This plugin allows Flutter desktop apps to Retrieve information about screen size, displays, cursor position, etc.

---

---

English | [简体中文](./README-ZH.md)

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Platform Support](#platform-support)
- [Documentation](#documentation)
- [Quick Start](#quick-start)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Listening events](#listening-events)
- [Who's using it?](#whos-using-it)
- [API](#api)
  - [ScreenRetriever](#screenretriever)
- [Contributors ✨](#contributors-)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Platform Support

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|  ✔️   |  ✔️   |   ✔️    |

## Documentation

- [Quick Start](https://leanflutter.dev/documentation/screen_retriever/quick-start)
- [API Reference](https://pub.dev/documentation/screen_retriever/latest/screen_retriever/)
- [Changelog](https://pub.dev/packages/screen_retriever/changelog)

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
