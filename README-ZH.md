# screen_retriever

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url] ![][visits-count-image] 

[pub-image]: https://img.shields.io/pub/v/screen_retriever.svg
[pub-url]: https://pub.dev/packages/screen_retriever

[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

[visits-count-image]: https://img.shields.io/badge/dynamic/json?label=Visits%20Count&query=value&url=https://api.countapi.xyz/hit/leanflutter.screen_retriever/visits

这个插件允许 Flutter 桌面应用检索关于屏幕大小，显示，光标位置等信息。

---

[English](./README.md) | 简体中文

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [screen_retriever](#screen_retriever)
  - [平台支持](#平台支持)
  - [快速开始](#快速开始)
    - [安装](#安装)
    - [用法](#用法)
  - [谁在用使用它？](#谁在用使用它)
  - [API](#api)
    - [ScreenRetriever](#screenretriever)
  - [许可证](#许可证)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 平台支持

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|   ✔️   |   ✔️   |    ✔️    |

## 快速开始

### 安装

将此添加到你的软件包的 pubspec.yaml 文件：

```yaml
dependencies:
  screen_retriever: ^0.1.2
```

或

```yaml
dependencies:
  screen_retriever:
    git:
      url: https://github.com/leanflutter/screen_retriever.git
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

> 请看这个插件的示例应用，以了解完整的例子。

## 谁在用使用它？

- [Biyi (比译)](https://biyidev.com/) - 一个便捷的翻译和词典应用。

## API

### ScreenRetriever

| Method                 | Description                                   | Linux | macOS | Windows |
| ---------------------- | --------------------------------------------- | ----- | ----- | ------- |
| `getCursorScreenPoint` | 返回 `Offset` - 鼠标指针的当前绝对位置。      | ✔️     | ✔️     | ✔️       |
| `getPrimaryDisplay`    | 返回 `Display` - 主显示屏。                   | ✔️     | ✔️     | ✔️       |
| `getAllDisplays`       | 返回 `List<Display>` - 当前可用的显示器列表。 | ✔️     | ✔️     | ✔️       |

## 许可证

[MIT](./LICENSE)
