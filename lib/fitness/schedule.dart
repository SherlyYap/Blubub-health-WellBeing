import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Schedule {
  final List<String> days;
  final String timeSlot; 
  final String workoutType;
  final DateTime startDate;

  Schedule({
    required this.days,
    required this.timeSlot,
    required this.workoutType,
    required this.startDate,
  });

  @override
  String toString() {
    return "${days.join(', ')} • $workoutType • $timeSlot • Mulai ${startDate.day}/${startDate.month}/${startDate.year}";
  }
}


const Map<String, String> timeSlotLabels = {
  "08:00": "08.00-10.00",
  "14:00": "14.00-16.00",
  "18:00": "18.00-20.00",
};

const List<String> timeSlots = ["08:00", "14:00", "18:00"];

const List<String> workoutTypes = [
  "Weight Training",
  "Fat Burn",
  "Yoga"
];

Future<Schedule?> showScheduleDialog(BuildContext context) async {
  final List<String> allDays = [
    "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"
  ];

  List<String> selectedDays = [];
  String selectedTimeSlot = timeSlots[0];
  String selectedWorkoutType = workoutTypes[0];
  DateTime? selectedDate;

  return await showModalBottomSheet<Schedule>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Jadwal Latihan",
                      style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 16),

                    Text("Pilih Hari:", style: GoogleFonts.nunito()),
                    Wrap(
                      spacing: 8,
                      children: allDays.map((day) {
                        return FilterChip(
                          label: Text(day),
                          selected: selectedDays.contains(day),
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                if (selectedDays.length < 3) {
                                  selectedDays.add(day);
                                }
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    if (selectedDays.length != 3)
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Pilih tepat 3 hari.",
                          style: GoogleFonts.nunito(color: Colors.red),
                        ),  
                      ),
                      const Divider(),

                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedTimeSlot,
                      decoration:  InputDecoration(
                        labelText: "Pilih Waktu Latihan",
                        labelStyle: GoogleFonts.nunito(),
                        border: OutlineInputBorder(),
                      ),
                      items: timeSlots.map((slot) {
                        return DropdownMenuItem(
                          value: slot,
                          child: Text(timeSlotLabels[slot]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTimeSlot = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedWorkoutType,
                      decoration:InputDecoration(
                        labelText: "Pilih Jenis Latihan",
                        labelStyle: GoogleFonts.nunito(),
                        border: OutlineInputBorder(),
                      ),
                      items: workoutTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWorkoutType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text(selectedDate == null
                          ? "Pilih Tanggal Mulai Langganan"
                          : "Tanggal Mulai: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                      onTap: () async {
                        DateTime now = DateTime.now();
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: now,
                          lastDate: DateTime(now.year + 1),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: selectedDays.length == 3 && selectedDate != null
                            ? () {
                                Navigator.pop(
                                  context,
                                  Schedule(
                                    days: selectedDays,
                                    timeSlot: selectedTimeSlot,
                                    workoutType: selectedWorkoutType,
                                    startDate: selectedDate!,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text(
                          "Confirm Jadwal",
                          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold ,color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
