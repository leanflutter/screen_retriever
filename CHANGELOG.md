## 0.3.0

screen_retriever is now built on [nativeapi](https://pub.dev/packages/nativeapi): the
federated plugin and its per-platform code are gone, and one C++ core drives macOS,
Windows and Linux.

* **Breaking:** `package:screen_retriever/screen_retriever.dart` exports the native
  API — `DisplayManager`, `Display` and the display events. A `Display` reads its
  values live and adds position, orientation, refresh rate, bit depth and
  `isPrimary`; `DisplayChangedEvent` reports changes, not only added and removed
  displays.
* The 0.2.x API moved to `package:screen_retriever/legacy.dart`: `screenRetriever`,
  `ScreenListener`, the old `Display`, and `ScreenRetrieverPlatform` for tests that
  replace it. Existing apps change one import. It is a bridge: everything in it is
  `@Deprecated` and will be removed in a later release. The README lists the
  behaviour differences and maps each old call to the native API.
* **Breaking:** requires Flutter 3.47 / Dart 3.13 and macOS 10.15. The
  `screen_retriever_platform_interface`, `screen_retriever_macos`,
  `screen_retriever_linux` and `screen_retriever_windows` packages are no longer
  used and get no further releases; `MethodChannelScreenRetriever` keeps its name
  but is backed by nativeapi.
* `Display.id` is the native display ID on every platform (it was empty on Linux),
  and `visiblePosition` / `visibleSize` are the work area everywhere (#16).
* Listeners also get `display-changed`, and removing the last listener stops the
  event stream instead of subscribing to it again.

## 0.2.2

* Bump `screen_retriever_macos` to 0.2.2 with fixed Package.swift
* Align all sub-packages to version 0.2.2

## 0.2.1

* Add Swift Package Manager support for macOS
* Fix null check in `ScreenRetriever._handleScreenEvent` (#27)
* Replace `mostly_reasonable_lints` with `flutter_lints`

## 0.2.0

* Convert to federated plugin
* Implement "display-added" and "display-removed" for all desktop platforms
* chore: Get the correct screen ID on Windows

## 0.1.9

* [windows] fix incorrect displays size

## 0.1.8

* [macos] fix getCursorScreenPoint method

## 0.1.7

* avoid nullptr as the param of fl_value_new_string (#15)
* Use primary screen to calculate visible positions (#13)

## 0.1.6

* Update Display to have final fields (#8)
* Fix compilation issues related to getAllDisplays (#7)

## 0.1.5

* Implement "display-added" and "display-removed" for Linux #5

## 0.1.4

* [linux] Fix memory management issues on Linux #4

## 0.1.3

* [linux] fix: crash when on wayland with no primary monitor #3

## 0.1.2

* [windows] Returns the correct `width` and `height`

## 0.1.1

* Add `visiblePosition`, `visibleSize` fields to `Display` model

## 0.1.0

* Support macOS Mojave.

## 0.0.2

* Support windows platform.

## 0.0.1

* First release.
