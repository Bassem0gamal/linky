
  import 'package:shared_preferences/shared_preferences.dart';

  class ChatRoomLastSeen {
    static final _instance = ChatRoomLastSeen._internal();

    final _prefs = SharedPreferences.getInstance();

    factory ChatRoomLastSeen() {
      return _instance;
    }

    ChatRoomLastSeen._internal();

    Future<DateTime> getLastMessage(String roomId) async {
      final prefs = await _prefs;
      final timeStamp = prefs.getInt(roomId) ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(timeStamp);
    }

    setLastMessage(String roomId, DateTime time) async {
      final prefs = await _prefs;
      await prefs.setInt(roomId, time.millisecondsSinceEpoch);
    }
  }