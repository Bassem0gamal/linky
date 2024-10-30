import 'package:cloud_firestore/cloud_firestore.dart';

class UserNamesService {
  static final _instance = UserNamesService._internal();
  final _cache = <String, String>{};

  factory UserNamesService() {
    return _instance;
  }

  UserNamesService._internal();

  Future<String> getUserName(String userId) async {
    if (_cache.containsKey(userId)) {
      return _cache[userId]!;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final name = userDoc.data()!['name'];
    _cache[userId] = name;

    return name;
  }
}