import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // ToDo: Add the Avatar Icon
        Icon(Icons.image),

        // ToDo: Add the UserName
        Text(
          'User name',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
