import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/screen/chat_screen.dart';
import 'package:linky/ui/data_source/users_name_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final userNameService = UserNamesService();

  List<QueryDocumentSnapshot<dynamic>> _allUsers = [];
  List _searchFilter = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchFilterResult);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchFilterResult);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getUsers();
    super.didChangeDependencies();
  }

  final _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searchController,
        ),
      ),
      body: ListView.builder(
        itemCount: _searchFilter.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _searchFilter[index]["name"],
            ),
            onTap: () {
              _navigateToChat(_searchFilter[index].id, );
            },
          );
        },
      ),
    );
  }

  getUsers() async {
    var data = await db.collection('users').orderBy('name').get();

    setState(() {
      _allUsers = data.docs.where((value) => user!.uid != value.id).toList();
    });
    _searchFilterResult();
  }

  _searchFilterResult() {
    List result = [];
    if (_searchController.text != "") {
      for (var snapshot in _allUsers) {
        var myId = user!.uid;
        var userId = snapshot.id;
        var name = snapshot['name'].toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase()) && userId != myId) {
          result.add(snapshot);
        }
      }
    } else {
      result = List.from(_allUsers);
    }
    setState(() {
      _searchFilter = result;
    });
  }

  Future<void> _navigateToChat(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatRoomId = getChatRoomId(currentUserId, otherUserId);

    final chatRoomDoc = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .get();

    if (chatRoomDoc.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            roomId: chatRoomId,
            otherUserId: otherUserId,
            lastMessage: (chatRoomDoc['last_message_time'] as Timestamp).toDate(),
          ),
        ),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .set({
        'members': [currentUserId, otherUserId],
        'last_message_time': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            roomId: chatRoomId,
            otherUserId: otherUserId,
            lastMessage: DateTime.now(),
          ),
        ),
      );
    }
  }

  String getChatRoomId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) < 0) {
      return '$userId1$userId2';
    } else {
      return '$userId2$userId1';
    }
  }
}
