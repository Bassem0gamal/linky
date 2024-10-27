import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String name;
  const ChatHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        // ToDo: Add the Avatar Icon
        CircleAvatar(
          backgroundColor: Colors.grey.shade500,
          child: const Text('Un', style: TextStyle(color: Colors.white),),
        ),

        const SizedBox(width: 8),

        Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
