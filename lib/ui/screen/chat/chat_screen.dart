
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/widget/chat_header.dart';
import 'package:linky/ui/widget/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.back)
        ),

        title: const Center(child: Padding(
          padding: EdgeInsets.all(70.0),
          child: ChatHeader(),
        )),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ChatWidget(alignment: Alignment.topLeft,),
            ChatWidget(alignment: Alignment.topRight,),
          ],
        ),
      ),
    );
  }
}
