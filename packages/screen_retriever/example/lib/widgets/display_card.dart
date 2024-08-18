import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';

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
