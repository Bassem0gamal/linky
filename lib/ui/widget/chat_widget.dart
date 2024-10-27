import 'package:flutter/material.dart';
import 'package:linky/ui/widget/chat_header.dart';

class ChatWidget extends StatelessWidget {
  final Alignment alignment;
  final String name;
  final String text;
  final String date;

  const ChatWidget(
      {super.key,
      required this.alignment,
      required this.name,
      required this.text,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      alignment: alignment,
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        color: Colors.grey[200],
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 6),
              child: ChatHeader(name: name),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Column(
                children: [
                  Text(text),
                  Text(date),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
