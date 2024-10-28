import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/widget/chat_header.dart';
import 'package:linky/ui/widget/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;

  const ChatScreen({
    super.key,
    required this.roomId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.all(70.0),
            child: ChatHeader(
              name: 'None',
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where("room_id", isEqualTo: widget.roomId).orderBy("time_stamp",descending: true)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return
                      ListView(
                        reverse: true,
                          children: snapshot.data!.docs.map((document) {
                        final map = document.data();

                        return ChatWidget(
                          name: 'senderName["user_name"]',
                          text: map["text"],
                          date: (document.get("time_stamp") as Timestamp).toDate(),
                          isMe: user!.uid == map["sender_id"],
                        );

                          }).toList());
                }),
          ),
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.white)
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _onMessageSend(_messageController.text, widget.roomId, user);
                        _messageController.clear();
                      },
                      icon: const Icon(Icons.send,color: Colors.white,)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

_onMessageSend(String messageText, String roomId ,user) async {
    const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.blue),
    );

    if(messageText.isNotEmpty) {
      final message = {
        'room_id': roomId,
        'sender_id': user!.uid,
        'text': messageText,
        'time_stamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection("messages").add(message);
    }
}