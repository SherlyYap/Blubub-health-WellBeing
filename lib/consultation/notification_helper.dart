import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:project/consultation/notification.dart';
import 'package:project/navigation_service.dart';
import 'package:project/consultation/notification_data.dart'; // ✅

void showCustomNotification({
  required String title,
  required String message,
}) {
  OverlaySupportEntry? entry;
  saveNotification(title, message);

  entry = showSimpleNotification(
    GestureDetector(
      onTap: () {
        entry?.dismiss();
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const NotificationsPage()),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.nunito(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(message,
                    style: GoogleFonts.nunito(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    ),
    background: const Color(0xff0D273D),
    duration: const Duration(seconds: 5),
  );
}
