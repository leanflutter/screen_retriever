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
- [快速开始](#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)
  - [安装](#%E5%AE%89%E8%A3%85)
  - [用法](#%E7%94%A8%E6%B3%95)
  - [监听事件](#%E7%9B%91%E5%90%AC%E4%BA%8B%E4%BB%B6)
- [谁在用使用它？](#%E8%B0%81%E5%9C%A8%E7%94%A8%E4%BD%BF%E7%94%A8%E5%AE%83)
- [API](#api)
  - [ScreenRetriever](#screenretriever)
- [许可证](#%E8%AE%B8%E5%8F%AF%E8%AF%81)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 平台支持

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|  ✔️   |  ✔️   |   ✔️    |

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

## 许可证

[MIT](./LICENSE)
