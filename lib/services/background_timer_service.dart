import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final prefs = await SharedPreferences.getInstance();
  final notifications = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  // 🔥 LISTEN STOP dari UI
  service.on('stopService').listen((event) async {
    await prefs.remove('endTime');
    await notifications.cancel(1);
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final endTimeMillis = prefs.getInt('endTime');

    if (endTimeMillis == null) {
      await notifications.cancel(1);
      timer.cancel();
      service.stopSelf();
      return;
    }

    final remaining =
        DateTime.fromMillisecondsSinceEpoch(endTimeMillis)
            .difference(DateTime.now());

    if (remaining.inSeconds <= 0) {
      await notifications.show(
        1,
        'Workout Selesai 💪',
        'Latihan telah berakhir',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'timer_channel',
            'Workout Timer',
            ongoing: false,
          ),
        ),
      );

      await prefs.remove('endTime');
      timer.cancel();
      service.stopSelf();
      return;
    }

    final m = remaining.inMinutes;
    final s = remaining.inSeconds % 60;

    service.invoke('update', {
      'time': '$m:${s.toString().padLeft(2, '0')}'
    });

    await notifications.show(
      1,
      'Workout Berjalan',
      'Sisa waktu: $m:${s.toString().padLeft(2, '0')}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_channel',
          'Workout Timer',
          ongoing: true,
          onlyAlertOnce: true,
        ),
      ),
    );
  });
}
