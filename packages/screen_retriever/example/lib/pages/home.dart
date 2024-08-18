import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:screen_retriever_example/widgets/display_card.dart';

class _ListSection extends StatelessWidget {
  const _ListSection({required this.title, required this.children});

  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 12,
            bottom: 6,
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium ?? const TextStyle(),
            child: title,
          ),
        ),
        ...children,
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScreenListener {
  Display? _primaryDisplay;
  List<Display> _displayList = [];

  @override
  void initState() {
    screenRetriever.addListener(this);
    super.initState();
    hotKeyManager.unregisterAll();
    hotKeyManager.register(
      HotKey(KeyCode.keyD, modifiers: [KeyModifier.alt]),
      keyDownHandler: (_) {
        _handleGetCursorScreenPoint();
      },
    );
    _getDisplays();
  }

  @override
  void dispose() {
    screenRetriever.removeListener(this);
    super.dispose();
  }

  @override
  void onScreenEvent(String eventName) {
    BotToast.showText(
      text: 'onScreenEvent: $eventName',
    );
    _getDisplays();
  }

  Future<void> _getDisplays() async {
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

  Widget _buildPrimaryDisplay(BuildContext context) {
    if (_primaryDisplay != null) {
      return _ListSection(
        title: const Text('Primary Display'),
        children: [
          DisplayCard(_primaryDisplay!),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildAllDisplays(BuildContext context) {
    if (_displayList.isNotEmpty) {
      return _ListSection(
        title: const Text('All Displays'),
        children: [
          for (var display in _displayList) DisplayCard(display),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildMethods(BuildContext context) {
    return _ListSection(
      title: const Text('Methods'),
      children: [
        Card(
          child: ListTile(
            title: const Text('getCursorScreenPoint'),
            trailing: const Text('Alt+D'),
            onTap: _handleGetCursorScreenPoint,
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('getPrimaryDisplay'),
            onTap: () async {
              _primaryDisplay = await screenRetriever.getPrimaryDisplay();
              setState(() {});
              BotToast.showText(
                text: 'primaryDisplay: ${_primaryDisplay!.toJson()}',
              );
            },
          ),
        ),
        Card(
          child: ListTile(
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
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _buildPrimaryDisplay(context),
        _buildAllDisplays(context),
        _buildMethods(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Retriever Example'),
      ),
      body: _buildBody(context),
    );
  }
}
