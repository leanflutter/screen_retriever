# 快速开始

按照以下步骤快速开始使用 `screen_retriever` 插件：

## 安装

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

### 要求

- Flutter 3.47 / Dart 3.13 及以上，macOS 10.15 及以上。
- Linux 构建机需要 GTK 3、X11 和 Xi 的开发包。

```
sudo apt-get install libgtk-3-dev libx11-dev libxi-dev
```

## 用法

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

从 0.2.x 升级？[README](https://github.com/leanflutter/screen_retriever/blob/main/README-ZH.md#从-02x-升级) 介绍了 `package:screen_retriever/legacy.dart`，并列出每个旧调用在原生 API 中的对应写法。
