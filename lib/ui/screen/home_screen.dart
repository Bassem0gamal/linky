import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/data_source/last_seen_service.dart';
import 'package:linky/ui/screen/chat_screen.dart';
import 'package:linky/ui/screen/search_screen.dart';
import 'package:linky/ui/data_source/users_name_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  final userNameService = UserNamesService();
  final _chatroomLastSeen = ChatRoomLastSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Padding(
            padding: EdgeInsets.all(100.0),
            child: Text('Linky'),
          ),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          })),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Log-out',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_rooms')
            .where("members", arrayContains: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              final map = document.data() as Map<String, dynamic>;
              final roomId = document.id;
              final lastMessage =
                  (map["last_message_time"] as Timestamp).toDate();
              final otherUserId = (map["members"] as List)
                  .firstWhere((userId) => userId != user!.uid);

              return FutureBuilder(
                  future: _chatroomLastSeen.getLastMessage(roomId),
                  builder: (context, snapshot) {
                    DateTime lastSeenMessage = snapshot.data ?? lastMessage;
                    return ListTile(
                      // ToDo: Replace with user's profile picture
                      leading: const CircleAvatar(),
                      title: FutureBuilder<String>(
                        future: UserNamesService().getUserName(
                            (map["members"] as List)
                                .firstWhere((userId) => userId != user!.uid)),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          return Text(snapshot.data ?? '');
                        },
                      ),
                      trailing: lastMessage.isAfter(lastSeenMessage)
                          ? const Icon(Icons.circle,
                              color: Colors.red, size: 10)
                          : null,
                      // ToDo: Replace with last message and timestamp
                      onTap: () {
                        _navigateToChat(
                          otherUserId,
                          roomId,
                          lastMessage,
                        );
                        setState(() {
                          lastSeenMessage = lastMessage;
                        });
                      },
                    );
                  });
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> _navigateToChat(
      String otherUserId, String chatRoomId, DateTime lastMessage) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          roomId: chatRoomId,
          otherUserId: otherUserId,
          lastMessage: lastMessage,
        ),
      ),
    );
  }
}
