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
                    .collection('massages')
                    .where("room_id", isEqualTo: widget.roomId)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return
                      ListView(
                          children: snapshot.data!.docs.map((document) {
                        final map = document.data();
                        final senderName = db.collection("users").doc(document["sender_Id"]).get();

                        return ChatWidget(
                          alignment: user!.uid == map["sender_Id"]
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          name: 'senderName["user_name"]',
                          text: map["text"],
                          date: map["timestamp"],
                        );
                      }).toList());
                }),
          ),
        ],
      ),
    );
  }
}
