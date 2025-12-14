import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/consultation/notification_helper.dart';
import 'package:project/consultation/chat_page.dart';
import 'package:project/consultation/booking_service.dart';
import 'package:project/localization/app_localizations.dart';

class DoctorDetailPage extends StatefulWidget {
  final Map<String, String> doctor;
  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

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
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            loc.translate('location_medan'),
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
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
                infoCard(loc.translate('patients'), "380+"),
                infoCard(loc.translate('experience'), "4 Yrs."),
                infoCard(loc.translate('rating'), "4.5"),
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
                      builder:
                          (_) => ChatPage(doctorName: widget.doctor['name']!),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(loc.translate('chat_doctor')),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                  section(
                    loc.translate('about_doctor'),
                    loc
                        .translate('about_doctor_desc')
                        .replaceAll(
                          '{specialist}',
                          widget.doctor['specialist']!,
                        ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                  section(
                    loc.translate('practice_hours'),
                    loc.translate('practice_time'),
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                   section(
                    loc.translate('reviews'),
                    "⭐⭐⭐⭐☆ 4.5 (150+ reviews)",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
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
                  loc.translate('book_appointment'),
                  style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBookingModal(BuildContext context) {
    final loc = AppLocalizations.of(context);

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
                      loc.translate('confirm_schedule'),
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0D273D),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    "${loc.translate('doctor_name')}: Dr. ${widget.doctor['name']}",
                    style: GoogleFonts.nunito(fontSize: 16),
                  ),
                  Text(
                    "${loc.translate('specialist')}: ${widget.doctor['specialist']}",
                    style: GoogleFonts.nunito(fontSize: 16),
                  ),
                  Text(
                    "${loc.translate('hospital')}: ${widget.doctor['hospital']}",
                    style: GoogleFonts.nunito(fontSize: 16),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    loc.translate('select_date'),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setModalState(() {
                          selectedDay =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(loc.translate('choose_date')),
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
                      child: Text(
                         "${loc.translate('selected_date')}: $selectedDay",
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 16),
                  Text(
                    loc.translate('select_time'),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton.icon(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
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
                    label: Text(loc.translate('choose_time')),
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
                        "${loc.translate('selected_time')}: ${selectedTime!.format(context)}",
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0D273D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:
                        (selectedDay.isNotEmpty && selectedTime != null)
                            ? () async {
                              Navigator.pop(context);

                              String formattedTime = selectedTime!.format(
                                context,
                              );

                              await BookingService.saveBooking(
                                doctorName: widget.doctor['name']!,
                                specialist: widget.doctor['specialist']!,
                                hospital: widget.doctor['hospital']!,
                                date: selectedDay,
                                time: formattedTime,
                              );
                              showCustomNotification(
                                title: loc.translate('booking_success'),
                                message:
                                    "${loc.translate('booking_success_desc')} Dr. ${widget.doctor['name']} ${loc.translate('at_time')} $formattedTime",
                              );
                            }
                            : null,
                    child: Text(
                      loc.translate('confirm_schedule'),
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
