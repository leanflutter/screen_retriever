import 'dart:async';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Display _primaryDisplay = const Display(id: 0, size: Size.zero);
  final _screenRetrieverPlugin = ScreenRetriever.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Display primaryDisplay = await _screenRetrieverPlugin.getPrimaryDisplay();

    if (!mounted) return;
    setState(() {
      _primaryDisplay = primaryDisplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: ${_primaryDisplay.toJson()}\n'),
        ),
      ),
    );
  }
}
