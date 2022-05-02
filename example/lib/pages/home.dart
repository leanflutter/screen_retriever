import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:preference_list/preference_list.dart';
import 'package:screen_retriever/screen_retriever.dart';

final hotKeyManager = HotKeyManager.instance;
final screenRetriever = ScreenRetriever.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScreenListener {
  Display? _primaryDisplay;
  List<Display> _displayList = [];

  @override
  void initState() {
    screenRetriever.addListener(this);
    super.initState();
    _init();
  }

  @override
  void dispose() {
    screenRetriever.removeListener(this);
    super.dispose();
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
            title: Text('Primary Display'),
            children: [
              PreferenceListItem(
                title: Text('${_primaryDisplay!.name}'),
                summary: Text('DisplayID: ${_primaryDisplay!.id}'),
              ),
            ],
          ),
        if (_displayList.length > 0)
          PreferenceListSection(
            title: Text('All Displays'),
            children: [
              for (var display in _displayList)
                PreferenceListItem(
                  title: Text('${display.name}'),
                  summary: Text('DisplayID: ${display.id}'),
                  onTap: () {
                    BotToast.showText(text: '${display.toJson()}');
                  },
                ),
            ],
          ),
        PreferenceListSection(
          title: Text('Methods'),
          children: [
            PreferenceListItem(
              title: Text('getCursorScreenPoint'),
              onTap: _handleGetCursorScreenPoint,
            ),
            PreferenceListItem(
              title: Text('getPrimaryDisplay'),
              onTap: () async {
                _primaryDisplay = await screenRetriever.getPrimaryDisplay();
                setState(() {});
                BotToast.showText(
                  text: 'primaryDisplay: ${_primaryDisplay!.toJson()}',
                );
              },
            ),
            PreferenceListItem(
              title: Text('getAllDisplays'),
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

  @override
  void onScreenEvent(String eventName) {
    print('[ScreenRetriever] onScreenEvent: $eventName');
  }
}
