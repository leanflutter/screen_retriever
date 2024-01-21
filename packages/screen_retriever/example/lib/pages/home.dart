import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:preference_list/preference_list.dart';
import 'package:screen_retriever/screen_retriever.dart';

final hotKeyManager = HotKeyManager.instance;
final screenRetriever = ScreenRetriever.instance;

class _DisplayItem extends StatelessWidget {
  final Display display;

  const _DisplayItem({Key? key, required this.display}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text('${display.name}'),
      summary: Text(
        [
          'id: ${display.id}',
          'size: ${display.size}',
          'visiblePosition: ${display.visiblePosition}',
          'visibleSize: ${display.visibleSize}',
          'scaleFactor: ${display.scaleFactor}',
        ].join('\n'),
      ),
      onTap: () {
        BotToast.showText(text: '${display.toJson()}');
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Display? _primaryDisplay;
  List<Display> _displayList = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // 初始化快捷键
    hotKeyManager.unregisterAll();
    hotKeyManager.register(
      HotKey(KeyCode.keyD, modifiers: [KeyModifier.alt]),
      keyDownHandler: (_) {
        _handleGetCursorScreenPoint();
      },
    );
    _primaryDisplay = await screenRetriever.getPrimaryDisplay();
    _displayList = await screenRetriever.getAllDisplays();
    setState(() {});
  }

  _handleGetCursorScreenPoint() async {
    Offset point = await screenRetriever.getCursorScreenPoint();
    BotToast.showText(
      text: 'cursorScreenPoint: $point',
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: <Widget>[
        if (_primaryDisplay != null)
          PreferenceListSection(
            title: const Text('Primary Display'),
            children: [
              _DisplayItem(display: _primaryDisplay!),
            ],
          ),
        if (_displayList.isNotEmpty)
          PreferenceListSection(
            title: const Text('All Displays'),
            children: [
              for (var display in _displayList) _DisplayItem(display: display),
            ],
          ),
        PreferenceListSection(
          title: const Text('Methods'),
          children: [
            PreferenceListItem(
              title: const Text('getCursorScreenPoint'),
              detailText: const Text('Alt+D'),
              onTap: _handleGetCursorScreenPoint,
            ),
            PreferenceListItem(
              title: const Text('getPrimaryDisplay'),
              onTap: () async {
                _primaryDisplay = await screenRetriever.getPrimaryDisplay();
                setState(() {});
                BotToast.showText(
                  text: 'primaryDisplay: ${_primaryDisplay!.toJson()}',
                );
              },
            ),
            PreferenceListItem(
              title: const Text('getAllDisplays'),
              onTap: () async {
                _displayList = await screenRetriever.getAllDisplays();
                setState(() {});
                BotToast.showText(
                  text:
                      'allDisplays:\n${_displayList.map((e) => e.toJson()).join('\n')}',
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildBody(context),
    );
  }
}
