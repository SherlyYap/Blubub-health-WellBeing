import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, String>> customNotifications = [];

Future<void> saveNotification(String title, String message) async {
  final prefs = await SharedPreferences.getInstance();

  // Tambahkan ke list runtime
  customNotifications.add({
    'title': title,
    'message': message,
    'time': DateTime.now().toIso8601String(),
  });

  // Simpan ke SharedPreferences
  await prefs.setString('notifications', jsonEncode(customNotifications));
}

Future<void> loadNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final String? stored = prefs.getString('notifications');
  if (stored != null) {
    customNotifications = List<Map<String, String>>.from(jsonDecode(stored));
  }
}

Future<void> clearNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('notifications');
  customNotifications.clear();
}
