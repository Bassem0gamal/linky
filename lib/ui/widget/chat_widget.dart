import 'package:flutter/material.dart';
import 'package:linky/ui/widget/chat_content.dart';
import 'package:linky/ui/widget/chat_header.dart';

class ChatWidget extends StatelessWidget {
  final Alignment alignment;

  const ChatWidget({super.key, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        color: Colors.grey[200],
        child: const Wrap(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 6),
              child: ChatHeader(),
            ),
            ChatContent(),
          ],
        ),
      ),
    );
  }
}
