import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/consultation/notification_data.dart';
import 'package:project/consultation/notification_helper.dart';
import 'package:project/consultation/chat_page.dart';
import 'package:project/consultation/booking_service.dart';

class DoctorDetailPage extends StatefulWidget {
  final Map<String, String> doctor;
  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  color: const Color(0xff0D273D),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.doctor['image']!),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Dr. ${widget.doctor['name']!}",
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.doctor['specialist']} • ${widget.doctor['hospital']}",
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text("Medan, Indonesia",
                              style: GoogleFonts.nunito(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                infoCard("PATIENTS", "380+"),
                infoCard("Experience", "4 Yrs."),
                infoCard("Rating", "4.5"),
              ],
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatPage(doctorName: widget.doctor['name']!),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Chat dengan Dokter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xff0D273D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xff0D273D)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

            // DETAIL INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                  section("Tentang Dokter",
                      "Dokter berpengalaman dalam bidang ${widget.doctor['specialist']}. Ramah, komunikatif, dan terpercaya."),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                  section("Jam Praktik", "Senin – Jumat: 07.00 – 16.30"),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                  section("Ulasan", "⭐⭐⭐⭐☆ 4.5 (150+ reviews)"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // BOOK BUTTON
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D273D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  showBookingModal(context);
                },
                child: Text(
                  "Book an Appointment",
                  style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =======================
  // BOOKING MODAL FUNCTION
  // =======================

  void showBookingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        String selectedDay = '';
        TimeOfDay? selectedTime;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xffCDD7DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      "Konfirmasi Jadwal",
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0D273D),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =============================
                  // INFO BOOKING
                  // =============================

                  Text("Nama Dokter: Dr. ${widget.doctor['name']}",
                      style: GoogleFonts.nunito(fontSize: 16)),
                  Text("Spesialis: ${widget.doctor['specialist']}",
                      style: GoogleFonts.nunito(fontSize: 16)),
                  Text("Rumah Sakit: ${widget.doctor['hospital']}",
                      style: GoogleFonts.nunito(fontSize: 16)),

                  const SizedBox(height: 12),

                  // PILIH TANGGAL
                  Text("Pilih Tanggal:",
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      );
                      if (pickedDate != null) {
                        setModalState(() {
                          selectedDay =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Pilih Tanggal"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0D273D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  if (selectedDay.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Tanggal yang dipilih: $selectedDay",
                          style: GoogleFonts.nunito(fontSize: 16)),
                    ),

                  const SizedBox(height: 16),

                  // PILIH WAKTU
                  Text("Pilih Waktu:",
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ElevatedButton.icon(
                    onPressed: () async {
                      TimeOfDay? pickedTime =
                          await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setModalState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: const Text("Pilih Waktu"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0D273D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  if (selectedTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                          "Waktu yang dipilih: ${selectedTime!.format(context)}",
                          style: GoogleFonts.nunito(fontSize: 16)),
                    ),

                  const SizedBox(height: 16),

                  // =============================
                  // KONFIRMASI BOOKING
                  // =============================

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0D273D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: (selectedDay.isNotEmpty && selectedTime != null)
                        ? () async {
                            Navigator.pop(context);

                            String formattedTime =
                                selectedTime!.format(context);

                            // SIMPAN KE FIRESTORE
                            await BookingService.saveBooking(
                              doctorName: widget.doctor['name']!,
                              specialist: widget.doctor['specialist']!,
                              hospital: widget.doctor['hospital']!,
                              date: selectedDay,
                              time: formattedTime,
                            );

                            // NOTIFIKASI CUSTOM
                            showCustomNotification(
                              title: "Booking Berhasil",
                              message:
                                  "Anda berhasil booking Dr. ${widget.doctor['name']} jam $formattedTime",
                            );

                            // SNACKBAR KONFIRMASI
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Jadwal pada $selectedDay pukul $formattedTime berhasil dikonfirmasi!',
                                  style: GoogleFonts.nunito(
                                      color: const Color(0XFF031716)),
                                ),
                                backgroundColor: const Color(0xffCDD7DF),
                              ),
                            );

                            // TAMBAH KE NOTIFIKASI LOKAL
                            customNotifications.insert(0, {
                              'emoji': '💬',
                              'title': 'Booking Berhasil',
                              'time': 'Baru saja',
                              'description':
                                  'Jadwal dengan Dr. ${widget.doctor['name']} telah dikonfirmasi untuk $selectedDay pukul $formattedTime.',
                              'action1': 'Lihat',
                            });

                            // NOTIFIKASI TAMBAHAN
                            Future.delayed(
                              const Duration(seconds: 8),
                              () {
                                showCustomNotification(
                                  title: "Pesan Baru",
                                  message:
                                      "Jadwal konsultasi kamu telah dikonfirmasi.",
                                );
                              },
                            );
                          }
                        : null,
                    child: Text(
                      "Konfirmasi Jadwal",
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // WIDGET KARTU INFO
  Widget infoCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.nunito(color: Color(0xff0D273D))),
        ],
      ),
    );
  }

  // WIDGET SECTION
  Widget section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: GoogleFonts.nunito(color: Color(0xff0D273D), fontSize: 14),
        ),
      ],
    );
  }
}
