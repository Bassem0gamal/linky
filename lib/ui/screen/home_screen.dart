import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/screen/chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Padding(
            padding: const EdgeInsets.all(100.0),
            child: const Text('Linky'),
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
                child: const Text('Log-out',style: TextStyle(color: Colors.white),),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                )
              ),
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

              return ListTile(
                leading: const CircleAvatar(),
                // ToDo: Replace with user's profile picture
                title: Text(map['name']),
                // ToDo: Replace with last message and timestamp
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(roomId: roomId),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
