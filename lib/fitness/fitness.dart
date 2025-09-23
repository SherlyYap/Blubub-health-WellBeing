import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/artikel.dart';
import 'package:project/fitness/calender_subs.dart';
import 'package:project/fitness/fat_burn_page.dart';
import 'package:project/fitness/home_workout_page.dart';
import 'package:project/fitness/subscriptionpage.dart';
import 'package:project/fitness/weight_training_page.dart';
import 'package:project/fitness/yoga_page.dart';
import 'package:project/global.dart';
import 'package:project/main_page.dart';
import 'package:project/consultation/notification.dart';
import 'package:project/fitness/progress_page.dart';

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class CalendarDateRange extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const CalendarDateRange({super.key, required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Subscription Period",
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          "${start.toLocal().toShort()} → ${end.toLocal().toShort()}",
          style: GoogleFonts.nunito(fontSize: 20),
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}

extension DateOnly on DateTime {
  String toShort() => "$day/$month/$year";
}

class CountdownWidget extends StatefulWidget {
  final Duration duration;

  const CountdownWidget({super.key, required this.duration});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Duration remaining;

  @override
  void initState() {
    super.initState();
    remaining = widget.duration;
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        remaining = remaining - const Duration(seconds: 1);
      });

      return remaining.inSeconds > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Next Workout in: ${remaining.inHours.toString().padLeft(2, '0')}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}",
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}

class MotivationalTextSwitcher extends StatefulWidget {
  const MotivationalTextSwitcher({super.key});

  @override
  State<MotivationalTextSwitcher> createState() =>
      _MotivationalTextSwitcherState();
}

class _MotivationalTextSwitcherState extends State<MotivationalTextSwitcher> {
  final List<String> messages = [
    "Semangat terus, kamu bisa!",
    "Latihan hari ini = hasil besok 💪",
    "Jangan menyerah! 🔥",
    "Progress dimulai dari konsistensi!",
    "Keep pushing forward!",
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startSwitch();
  }

  void _startSwitch() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      setState(() {
        currentIndex = (currentIndex + 1) % messages.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      messages[currentIndex],
      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 202, 231, 255)),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color.fromARGB(255, 202, 231, 255)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPromoCard(context),
                    const SizedBox(height: 10),
                    _buildWorkoutSection(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    if (confirmedSchedule == null || confirmedPlan == null) {
      return Container(
        height: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage('img-project/fitness_test1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Start Your Fitness Journey Today!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionPage(),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0D273D),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'TRY IT NOW!!',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    DateTime now = DateTime.now();
    DateTime startDate = confirmedStartDate ?? now;
    DateTime endDate =
        confirmedEndDate ?? startDate.add(const Duration(days: 30));

    Duration? timeToNextWorkout;

    for (String day in confirmedSchedule!.days) {
      final nextWorkout = _getNextWorkoutTime(
        startDate,
        day,
        confirmedSchedule!.timeSlot,
      );

      if (nextWorkout != null) {
        final duration = nextWorkout.difference(DateTime.now());
        if (timeToNextWorkout == null || duration < timeToNextWorkout) {
          timeToNextWorkout = duration;
        }
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CalendarDateRange(start: startDate, end: endDate),
            SubscriptionCalendar(startDate: startDate, endDate: endDate),

            const SizedBox(height: 12),

            if (timeToNextWorkout != null)
              CountdownWidget(duration: timeToNextWorkout)
            else
              const Text("Tidak ada jadwal latihan minggu ini."),

            const Divider(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Schedule:",
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children:
                  confirmedSchedule!.days
                      .map(
                        (d) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Chip(label: Text(d)),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text("Start Time: ${confirmedSchedule!.timeSlot}"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.fitness_center),
                const SizedBox(width: 8),
                Text("Workout Type: ${confirmedSchedule!.workoutType}"),
              ],
            ),

            const SizedBox(height: 12),
            MotivationalTextSwitcher(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSection(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        latihanCard(
          'home workout',
          'img-project/home_workout.jpg',
          "Latihan untuk melatih otot dengan berat badan sendiri",
          context,
        ),
        latihanCard(
          'weight training',
          'img-project/weight_training.jpg',
          "Latihan untuk meningkatkan kekuatan otot dan massa otot",
          context,
        ),
        latihanCard(
          'fat burn',
          'img-project/fat_burn.jpg',
          "Latihan untuk menurunkan berat badan dan membakar lemak",
          context,
        ),
        latihanCard(
          'Yoga',
          'img-project/yoga.jpg',
          "Latihan untuk flexibilitas dan pernafasan serta keseimbangan",
          context,
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xff0D273D)),
            child: Text(
              'Fitness Menu',
              style: GoogleFonts.nunito(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          _drawerItem(Icons.bar_chart, 'Progress', const ProgressPage()),

          _drawerItem(
            Icons.fitness_center,
            'Home Workout',
            const HomeWorkoutPage(),
          ),
          _drawerItem(
            Icons.fitness_center,
            'Weight Training',
            const weight_training_page(),
          ),
          _drawerItem(
            Icons.local_fire_department,
            'Fat Burn',
            const FatBurnPage(),
          ),
          _drawerItem(Icons.self_improvement, 'Yoga', const YogaPage()),
          _drawerItem(
            Icons.subscriptions,
            'Subscription',
            const SubscriptionPage(),
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  BottomNavigationBar _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xff0D273D),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainMenuPage()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ArticlePage()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Inbox'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Article'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }

  Widget latihanCard(
    String nama,
    String imageAsset,
    String deskripsi,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        if (nama.toLowerCase() == 'home workout') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HomeWorkoutPage()),
          );
        } else if (nama.toLowerCase() == 'weight training') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const weight_training_page()),
          );
        } else if (nama.toLowerCase() == 'fat burn') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FatBurnPage()),
          );
        } else if (nama.toLowerCase() == 'yoga') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const YogaPage()),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama.toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    deskripsi,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime? _getNextWorkoutTime(DateTime startDate, String day, String timeSlot) {
  final dayMap = {
    'Senin': DateTime.monday,
    'Selasa': DateTime.tuesday,
    'Rabu': DateTime.wednesday,
    'Kamis': DateTime.thursday,
    'Jumat': DateTime.friday,
    'Sabtu': DateTime.saturday,
    'Minggu': DateTime.sunday,
  };

  int targetWeekday = dayMap[day]!;

  final parts = timeSlot.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  DateTime now = DateTime.now();
  DateTime next = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
    hour,
    minute,
  );

  int tries = 0;
  while (true) {
    if (next.weekday == targetWeekday && next.isAfter(now)) {
      return next;
    }
    next = next.add(const Duration(days: 1));
    next = DateTime(next.year, next.month, next.day, hour, minute);
    if (++tries > 14) return null;
  }
}
