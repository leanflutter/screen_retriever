> **screen_retriever 基于 [nativeapi](https://github.com/libnativeapi/nativeapi) 构建**——它是统一的
> C++ 核心库（[libnativeapi/nativeapi](https://github.com/libnativeapi/nativeapi)）的 Flutter 绑定，macOS、Windows、Linux
> 共用同一套实现。从 0.2.x 升级？请看[从 0.2.x 升级](#从-02x-升级)。

# screen_retriever

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url]

[pub-image]: https://img.shields.io/pub/v/screen_retriever.svg
[pub-url]: https://pub.dev/packages/screen_retriever
[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

这个包让 Flutter 桌面应用读取显示器信息（尺寸、工作区、缩放比例）和光标位置，并在显示器
接入、移除或变化时收到通知。

[English](./README.md) | 简体中文

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [平台支持](#平台支持)
- [快速开始](#快速开始)
  - [安装](#安装)
    - [要求](#要求)
  - [用法](#用法)
    - [从 0.2.x 升级](#从-02x-升级)
    - [迁移到原生 API](#迁移到原生-api)
- [谁在使用它？](#谁在使用它)
- [API](#api)
  - [原生 API](#原生-api)
- [贡献者 ✨](#贡献者-)
- [许可证](#许可证)

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
  screen_retriever: ^0.3.0
```

或

```yaml
dependencies:
  screen_retriever:
    git:
      url: https://github.com/leanflutter/screen_retriever.git
      ref: main
```

#### 要求

- Flutter 3.47 / Dart 3.13 及以上，macOS 10.15 及以上。
- Linux 构建机需要 GTK 3、X11 和 Xi 的开发包。

```
sudo apt-get install libgtk-3-dev libx11-dev libxi-dev
```

### 用法

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

位置和尺寸都是逻辑像素，原点在主显示器的左上角。nativeapi 的 `Point`、`Size`、`Rectangle`
没有导出，因为 Flutter 有自己的 `Size`：用 `toOffset()`、`toSize()`、`toRect()` 转成 Flutter 的类型。

> 本插件的[示例应用](./example)演示的是兼容 0.2.x 的 API。

#### 从 0.2.x 升级

为 `screen_retriever` 0.2.x 写的代码，把 `package:screen_retriever/screen_retriever.dart`
换成 `package:screen_retriever/legacy.dart` 即可继续使用。它在原生 API 之上提供原来的
`screenRetriever`、`ScreenListener`、`Display` 和 `ScreenRetrieverPlatform`。

需要改 import 是有意为之：`legacy.dart` 只是过渡，不是这个包的方向。其中的类都标记了
`@Deprecated`，**会在之后的版本中移除**——请尽早迁移到上面的原生 API。

```dart
import 'package:screen_retriever/legacy.dart';

final primaryDisplay = await screenRetriever.getPrimaryDisplay();
final displays = await screenRetriever.getAllDisplays();
final cursor = await screenRetriever.getCursorScreenPoint();
```

与 0.2.x 的差异：

- 构建需要 Flutter 3.47 / Dart 3.13 和 macOS 10.15（0.2.x：Flutter 3.3）。
  `screen_retriever_platform_interface`、`_macos`、`_linux`、`_windows` 这些包不再使用。
- `Display.id` 是 nativeapi 的显示器 ID 的文本形式。显示器保持连接期间不变，但重启应用或
  重新连接后会变；0.2.x 在 macOS 和 Windows 上用的是平台自己的 ID，在 Linux 上是空字符串。
- Windows 上的 `name` 是显示器自己的名称（如 "DELL U2720Q"，Windows 没有名称时为
  "Generic PnP Monitor"），不再是 `\\.\DISPLAY1`。
- `visiblePosition` 和 `visibleSize` 在所有平台上都是工作区，即去掉菜单栏、任务栏或面板之后的区域。
- Windows 上的尺寸不再取整，150% 缩放的显示器可能得到 `1706.67` 这样的逻辑像素值。
- `ScreenListener` 除了 `display-added`、`display-removed`，还会收到 `display-changed`。
- `MethodChannelScreenRetriever` 保留了名字，仍是默认的 `ScreenRetrieverPlatform`，但已经没有
  method channel：它的 `methodChannel` 和 `eventChannel` 字段已移除。替换
  `ScreenRetrieverPlatform.instance` 的测试照常可用。

#### 迁移到原生 API

| 0.2.x（`legacy.dart`） | 原生 API（`screen_retriever.dart`） |
| --- | --- |
| `await screenRetriever.getPrimaryDisplay()` | `DisplayManager.instance.getPrimary()`——同步调用，没有主显示器时为 `null` |
| `await screenRetriever.getAllDisplays()` | `DisplayManager.instance.getAll()` |
| `await screenRetriever.getCursorScreenPoint()` | `DisplayManager.instance.getCursorPosition().toOffset()` |
| `display.id`（`String`） | `display.id`（`DisplayId`，即 `int`） |
| `display.size` | `display.size.toSize()` |
| `display.visiblePosition`、`display.visibleSize` | `display.workArea.toRect()` |
| `display.name`、`display.scaleFactor` | 相同，实时读取 |
| — | `display.position`、`isPrimary`、`orientation`、`refreshRate`、`bitDepth` |
| `ScreenListener` 配合 `screenRetriever.addListener` | `DisplayManager.instance.addListener((event) { ... })`，返回的 ID 用于 `removeListener` |
| `onScreenEvent('display-added')`、`'display-removed'` | `DisplayAddedEvent`、`DisplayRemovedEvent`、`DisplayChangedEvent`，各自带有 `display` |
| `display.toJson()` | ——原生 `Display` 实时读取属性，需要保存的值请自行复制 |

原生 `Display` 是系统显示器的句柄：从 `getAll()` 或 `getPrimary()` 拿到的用完后调用
`dispose()`，或者交给垃圾回收。

## 谁在使用它？

- [Biyi (比译)](https://biyidev.com/) - 一个便捷的翻译和词典应用。

## API

### 原生 API

`screen_retriever` 重新导出了 `nativeapi` 的显示器 API：`DisplayManager`、`Display`、
`DisplayEvent` 及其子类、`DisplayId` 和 `DisplayOrientation`，以及 `nativeapi_flutter` 的
`toOffset()`、`toSize()`、`toRect()` 转换。只有仍在使用 0.2.x API 的代码才需要 import
`package:screen_retriever/legacy.dart`。

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
