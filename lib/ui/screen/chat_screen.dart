import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/data_source/last_seen_service.dart';
import 'package:linky/ui/data_source/users_name_service.dart';
import 'package:linky/ui/widget/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final DateTime lastMessage;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.otherUserId,
    required this.lastMessage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  final _chatroomLastSeen = ChatRoomLastSeen();

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _chatroomLastSeen.setLastMessage(widget.roomId, widget.lastMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
        title: FutureBuilder(
          future: UserNamesService().getUserName(widget.otherUserId),
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Text(
              snapshot.data ?? 'Loading..',
              style: const TextStyle(fontSize: 18),
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where("room_id", isEqualTo: widget.roomId)
                    .orderBy("time_stamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((document) {
                        final map = document.data();

                        return ChatWidget(
                          text: map["text"],
                          date: (document.get("time_stamp") as Timestamp?)
                              ?.toDate() ??
                              DateTime.now(),
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
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _onMessageSend(
                            _messageController.text, widget.roomId, user);
                        _messageController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

_onMessageSend(String messageText, String roomId, user) async {
  const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Colors.blue),
  );

  if (messageText.isNotEmpty) {
    final message = {
      'room_id': roomId,
      'sender_id': user!.uid,
      'text': messageText,
      'time_stamp': FieldValue.serverTimestamp(),
    };

    final chatRoomPayLoad = {
      'time_stamp': FieldValue.serverTimestamp()
    };

    await FirebaseFirestore.instance.collection("messages").add(message);

    await FirebaseFirestore.instance.collection('chat_rooms')
        .doc(roomId)
        .update(chatRoomPayLoad);
  }
}
