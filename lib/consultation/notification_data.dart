import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, String>> customNotifications = [];
Future<void> saveNotification({
  required String title,
  required String message,
  String? docId,
}) async {
  final prefs = await SharedPreferences.getInstance();

  customNotifications.add({
    'title': title,
    'message': message,
    'time': DateTime.now().toIso8601String(),
    'docId': docId ?? '',
  });

  await prefs.setString('notifications', jsonEncode(customNotifications));
}
Future<void> loadNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString('notifications');

  if (stored != null) {
    final List decoded = jsonDecode(stored);

    customNotifications = decoded.map((item) {
      return Map<String, String>.from(
        item.map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    }).toList();
  }
}

Future<void> clearNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('notifications');
  for (var n in customNotifications) {
    if (n["docId"] != null && n["docId"]!.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(n["docId"])
          .delete()
          .catchError((_) {});
    }
  }

  customNotifications.clear();
}
Future<void> deleteNotificationAt(int index) async {
  final prefs = await SharedPreferences.getInstance();

  final docId = customNotifications[index]['docId'];
  if (docId != null && docId.isNotEmpty) {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(docId)
        .delete()
        .catchError((_) {});
  }
  customNotifications.removeAt(index);
  await prefs.setString('notifications', jsonEncode(customNotifications));
}
