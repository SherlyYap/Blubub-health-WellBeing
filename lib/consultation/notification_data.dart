import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, String>> customNotifications = [];

Future<void> saveNotification(String title, String message) async {
  final prefs = await SharedPreferences.getInstance();

  customNotifications.add({
    'title': title,
    'message': message,
    'time': DateTime.now().toIso8601String(),
  });

  await prefs.setString('notifications', jsonEncode(customNotifications));
}

Future<void> loadNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final String? stored = prefs.getString('notifications');
  if (stored != null) {
    final List<dynamic> decoded = jsonDecode(stored);

    customNotifications =
        decoded.map((item) {
          return Map<String, String>.from(
            item.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          );
        }).toList();
  }
}

Future<void> clearNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('notifications');
  customNotifications.clear();
}
