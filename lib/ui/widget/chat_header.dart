import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String name;
  const ChatHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
