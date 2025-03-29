> **🚀 快速发布您的应用**: 试试 [Fastforge](https://fastforge.dev) - 构建、打包和分发您的 Flutter 应用最简单的方式。

# screen_retriever

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url]

[pub-image]: https://img.shields.io/pub/v/screen_retriever.svg
[pub-url]: https://pub.dev/packages/screen_retriever
[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

这个插件允许 Flutter 桌面应用检索关于屏幕大小，显示，光标位置等信息。

---

[English](./README.md) | 简体中文

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [平台支持](#%E5%B9%B3%E5%8F%B0%E6%94%AF%E6%8C%81)
- [文档](#%E6%96%87%E6%A1%A3)
- [快速开始](#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)
  - [安装](#%E5%AE%89%E8%A3%85)
  - [用法](#%E7%94%A8%E6%B3%95)
  - [监听事件](#%E7%9B%91%E5%90%AC%E4%BA%8B%E4%BB%B6)
- [谁在用使用它？](#%E8%B0%81%E5%9C%A8%E7%94%A8%E4%BD%BF%E7%94%A8%E5%AE%83)
- [API](#api)
  - [ScreenRetriever](#screenretriever)
- [贡献者 ✨](#%E8%B4%A1%E7%8C%AE%E8%80%85-)
- [许可证](#%E8%AE%B8%E5%8F%AF%E8%AF%81)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 平台支持

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|  ✔️   |  ✔️   |   ✔️    |

## 文档

- [快速开始](https://leanflutter.dev/zh/documentation/screen_retriever/quick-start)
- [API 参考](https://pub.dev/documentation/screen_retriever/latest/screen_retriever/)
- [更新日志](https://pub.dev/packages/screen_retriever/changelog)

## 快速开始

### 安装

将此添加到你的软件包的 pubspec.yaml 文件：

```yaml
dependencies:
  screen_retriever: ^0.2.0
```

或

```yaml
dependencies:
  screen_retriever:
    git:
      url: https://github.com/leanflutter/screen_retriever.git
      path: packages/screen_retriever
      ref: main
```

### 用法

```dart
Display? _primaryDisplay;
List<Display> _displayList = [];

void _init() async {
  _primaryDisplay = await screenRetriever.getPrimaryDisplay();
  _displayList = await screenRetriever.getAllDisplays();
  setState(() {});
}
```

### 监听事件

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

> 请看这个插件的示例应用，以了解完整的例子。

## 谁在用使用它？

- [Biyi (比译)](https://biyidev.com/) - 一个便捷的翻译和词典应用。

## API

### ScreenRetriever

| Method                 | Description                                   | Linux | macOS | Windows |
| ---------------------- | --------------------------------------------- | ----- | ----- | ------- |
| `getCursorScreenPoint` | 返回 `Offset` - 鼠标指针的当前绝对位置。      | ✔️    | ✔️    | ✔️      |
| `getPrimaryDisplay`    | 返回 `Display` - 主显示屏。                   | ✔️    | ✔️    | ✔️      |
| `getAllDisplays`       | 返回 `List<Display>` - 当前可用的显示器列表。 | ✔️    | ✔️    | ✔️      |

## 贡献者 ✨

感谢这些优秀的人 ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

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

## 许可证

[MIT](./LICENSE)
