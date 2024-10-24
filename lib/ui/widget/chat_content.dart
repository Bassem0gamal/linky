import 'package:flutter/material.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: const Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
          " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
          " when an unknown printer took a galley of type and scrambled it to make a type specimen book."
          " It has survived not only five centuries, but also the leap into electronic typesetting,"
          " remaining essentially unchanged."
          " It was popularised in the 1960s with the release of Letraset sheets containing "),
    );
  }
}
