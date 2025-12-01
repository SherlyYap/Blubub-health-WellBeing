import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  static Future<void> saveBooking({
    required String doctorName,
    required String specialist,
    required String hospital,
    required String date,
    required String time,
  }) async {
    await FirebaseFirestore.instance.collection('bookings').add({
      "doctorName": doctorName,
      "specialist": specialist,
      "hospital": hospital,
      "date": date,
      "time": time,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
