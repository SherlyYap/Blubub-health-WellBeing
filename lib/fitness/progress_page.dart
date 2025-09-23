import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Map<DateTime, List<String>> events = {};

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('events');

    if (raw != null) {
      final decoded = json.decode(raw) as Map<String, dynamic>;

      setState(() {
        events = decoded.map((key, value) {
          return MapEntry(DateTime.parse(key), List<String>.from(value));
        });
      });
    } else {
      events = {
        DateTime.utc(2025, 12, 3): ['Strength Training'],
        DateTime.utc(2025, 12, 4): ['Flexibility Session'],
        DateTime.utc(2025, 12, 5): ['Cardio Day'],
      };
    }
  }

  Future<void> saveEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> raw = events.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    });

    await prefs.setString('events', json.encode(raw));
  }

  List<String> getEventsForDay(DateTime day) {
    final dayKey = DateTime.utc(day.year, day.month, day.day);
    return events[dayKey] ?? [];
  }

  void addEvent(DateTime day, String event) async {
    final dayKey = DateTime.utc(day.year, day.month, day.day);
    setState(() {
      events.putIfAbsent(dayKey, () => []);
      events[dayKey]!.add(event);
    });
    await saveEvents();
  }

  void deleteEvent(DateTime day, String event) async {
    final dayKey = DateTime.utc(day.year, day.month, day.day);

    setState(() {
      events[dayKey]?.remove(event);
      if (events[dayKey]?.isEmpty ?? true) {
        events.remove(dayKey);
      }
    });

    await saveEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YOUR PROGRESS',
          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff0D273D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    donutChart('January'),
                    const SizedBox(width: 12),
                    donutChart('February'),
                    const SizedBox(width: 12),
                    donutChart('March'),
                    const SizedBox(width: 12),
                    donutChart('April'),
                    const SizedBox(width: 12),
                    donutChart('May'),
                    const SizedBox(width: 12),
                    donutChart('June'),
                    const SizedBox(width: 12),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              progressRow("Strength", Colors.red, 0.75),
              const SizedBox(height: 12),
              progressRow("Flexibility", Colors.green, 0.50),
              const SizedBox(height: 12),
              progressRow("Cardio", Colors.blue, 0.35),

              const SizedBox(height: 20),

              Row(
                children:  [
                  Icon(Icons.calendar_today, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    "Set a reminder for you",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(day, selectedDay);
                },
                eventLoader: getEventsForDay,
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false, 
                ),
              ),

              const SizedBox(height: 10),

              if (selectedDay != null)
                ...getEventsForDay(selectedDay!).map((event) {
                  return ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(event, style: GoogleFonts.nunito(),),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteEvent(selectedDay!, event);
                      },
                    ),
                  );
                }).toList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0D273D),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          if (selectedDay == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pilih tanggal dulu.', style: GoogleFonts.nunito())),
            );
            return;
          }

          final controller = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Tambah Event', style: GoogleFonts.nunito(),),
                content: TextField(
                  controller: controller,
                  decoration:  InputDecoration(hintText: 'Nama Event', hintStyle: GoogleFonts.nunito()),
                ),
                actions: [
                  TextButton(
                    child: Text('BATAL', style: GoogleFonts.nunito()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: Text('SIMPAN', style: GoogleFonts.nunito()),
                    onPressed: () {
                      Navigator.pop(context, controller.text);
                    },
                  ),
                ],
              );
            },
          );

          if (result != null && result.trim().isNotEmpty) {
            addEvent(selectedDay!, result.trim());
          }
        },
      ),
    );
  }

  Widget donutChart(String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 120,
        height: 150,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 20,
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: 35,
                      title: '',
                      radius: 10,
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 35,
                      title: '',
                      radius: 10,
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 30,
                      title: '',
                      radius: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget progressRow(String label, Color color, double percent) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style:  GoogleFonts.nunito(fontSize: 16)),
        ),
        Expanded(
          flex: 5,
          child: LinearPercentIndicator(
            lineHeight: 12,
            percent: percent,
            backgroundColor: Colors.grey[300],
            progressColor: color,
            center: Text(
              "${(percent * 100).toInt()} %",
              style:  GoogleFonts.nunito(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
