import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/consultation/notification_data.dart';
import 'package:project/consultation/notification_helper.dart';

class BookingService {
  static Future<void> saveBooking({
    required String doctorName,
    required String specialist,
    required String hospital,
    required String date,
    required String time,
  }) async {
    final docRef = await FirebaseFirestore.instance.collection('bookings').add({
      "doctorName": doctorName,
      "specialist": specialist,
      "hospital": hospital,
      "date": date,
      "time": time,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await saveNotification(
      title: "Booking Berhasil",
      message: "Booking dengan $doctorName pada $date pukul $time",
      docId: docRef.id,
    );

    showCustomNotification(
      title: "Booking Berhasil",
      message: "Booking dengan $doctorName pada $date pukul $time",
    );
  }
}
