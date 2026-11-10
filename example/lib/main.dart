// The example shows the deprecated 0.2.x compatible API on purpose.
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screen_retriever/legacy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const HomePage(),
    );
  }
}

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
          padding: const EdgeInsets.only(left: 20, top: 12, bottom: 6),
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
  String? _loadError;

  @override
  void initState() {
    super.initState();
    screenRetriever.addListener(this);
    unawaited(_getDisplays());
  }

  @override
  void dispose() {
    screenRetriever.removeListener(this);
    super.dispose();
  }

  @override
  void onScreenEvent(String eventName) {
    BotToast.showText(text: 'onScreenEvent: $eventName');
    unawaited(_getDisplays());
  }

  Future<void> _getDisplays() async {
    Display? primary;
    List<Display> displays = [];
    String? error;
    try {
      primary = await screenRetriever.getPrimaryDisplay();
      displays = await screenRetriever.getAllDisplays();
    } catch (e) {
      // The primary display can briefly be missing while a monitor is unplugged.
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      _primaryDisplay = primary;
      _displayList = displays;
      _loadError = error;
    });
  }

  Future<void> _handleGetCursorScreenPoint() async {
    try {
      final point = await screenRetriever.getCursorScreenPoint();
      BotToast.showText(text: 'cursorScreenPoint: $point');
    } catch (error) {
      BotToast.showText(text: 'getCursorScreenPoint failed: $error');
    }
  }

  Future<void> _handleGetPrimaryDisplay() async {
    try {
      final primary = await screenRetriever.getPrimaryDisplay();
      if (!mounted) return;
      setState(() {
        _primaryDisplay = primary;
        _loadError = null;
      });
      BotToast.showText(text: 'primaryDisplay: ${primary.toJson()}');
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error.toString());
    }
  }

  Future<void> _handleGetAllDisplays() async {
    try {
      final displays = await screenRetriever.getAllDisplays();
      if (!mounted) return;
      setState(() {
        _displayList = displays;
        _loadError = null;
      });
      BotToast.showText(
        text: 'allDisplays:\n${displays.map((e) => e.toJson()).join('\n')}',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error.toString());
    }
  }

  Widget _buildPrimaryDisplay(BuildContext context) {
    if (_primaryDisplay != null) {
      return _ListSection(
        title: const Text('Primary Display'),
        children: [DisplayCard(_primaryDisplay!)],
      );
    }
    return const SizedBox();
  }

  Widget _buildAllDisplays(BuildContext context) {
    if (_displayList.isNotEmpty) {
      return _ListSection(
        title: const Text('All Displays'),
        children: [for (var display in _displayList) DisplayCard(display)],
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
            onTap: _handleGetCursorScreenPoint,
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('getPrimaryDisplay'),
            onTap: _handleGetPrimaryDisplay,
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('getAllDisplays'),
            onTap: _handleGetAllDisplays,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (_loadError != null) Text('Could not read displays: $_loadError'),
        _buildPrimaryDisplay(context),
        _buildAllDisplays(context),
        _buildMethods(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Retriever Example')),
      body: _buildBody(context),
    );
  }
}

class DisplayCard extends StatelessWidget {
  const DisplayCard(this.display, {super.key});

  final Display display;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${display.name}'),
        subtitle: Text(
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
      ),
    );
  }
}
