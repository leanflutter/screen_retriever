import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ffi/ffi.dart';

import 'package:screen_retriever_ffi/screen_retriever_ffi.dart'
    as screen_retriever_ffi;
import 'package:screen_retriever_ffi/screen_retriever_ffi_bindings_generated.dart';

extension DisplayExtension on Display {
  Map<String, dynamic> toJson() {
    return {
      'id': id.cast<Utf8>().toDartString(),
      'name': name.cast<Utf8>().toDartString(),
      'width': width,
      'height': height,
      'visiblePositionX': visiblePositionX,
      'visiblePositionY': visiblePositionY,
      'visibleSizeWidth': visibleSizeWidth,
      'visibleSizeHeight': visibleSizeHeight,
      'scaleFactor': scaleFactor,
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int sumResult;
  late Future<int> sumAsyncResult;
  late Display primaryDisplay;
  late int allDisplays;

  @override
  void initState() {
    super.initState();
    sumResult = screen_retriever_ffi.sum(1, 2);
    sumAsyncResult = screen_retriever_ffi.sumAsync(3, 4);
    primaryDisplay = screen_retriever_ffi.getPrimaryDisplay();
    allDisplays = screen_retriever_ffi.getAllDisplays();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'sum(1, 2) = $sumResult',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                FutureBuilder<int>(
                  future: sumAsyncResult,
                  builder: (BuildContext context, AsyncSnapshot<int> value) {
                    final displayValue =
                        (value.hasData) ? value.data : 'loading';
                    return Text(
                      'await sumAsync(3, 4) = $displayValue',
                      style: textStyle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                spacerSmall,
                Text(
                  'primaryDisplay = ${json.encode(primaryDisplay.toJson())}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'allDisplays = $allDisplays',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
