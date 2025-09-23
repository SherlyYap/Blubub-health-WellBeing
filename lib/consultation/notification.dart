import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/artikel.dart';
import 'package:project/main_page.dart';
import 'package:project/consultation/notification_data.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color.fromARGB(255, 202, 231, 255),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Notifications',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (var notif in customNotifications)
                    NotificationCard(
                      emoji: notif['emoji'] ?? '🔔',
                      title: notif['title'] ?? '',
                      time: notif['time'] ?? '',
                      description: notif['description'] ?? '',
                      action1: notif['action1'] ?? '',
                    ),
                  const NotificationCard(
                    emoji: "🟢",
                    title: "Reminder!",
                    time: "23 min",
                    description:
                        "Doctor appointment today at 6:30pm, need to pick up files on the way.",
                    action1: "Mark as done",
                    action2: "Update",
                  ),
                  const NotificationCard(
                    emoji: "❤️",
                    title: "Your weekly health tip is ready!",
                    time: "2 hr",
                    description:
                        "We've prepared your weekly health tip to help you improve your mood.",
                    action1: "Open weekly tips",
                  ),
                  const NotificationCard(
                    emoji: "⚖️",
                    title: "It’s time to enter your weight",
                    time: "1 d",
                    description:
                        "Track your weight and help us customize your weekly health tip for you.",
                    action1: "Add weight entry",
                  ),
                  const NotificationCard(
                    emoji: "📅",
                    title: "Moment remainder!",
                    time: "1 wk",
                    description:
                        "Doctor appointment today at 6:30pm, need to pick up files on the way.",
                    action1: "View",
                    action2: "Update",
                  ),
                  const NotificationCard(
                    emoji: "⚖️",
                    title: "It’s time to enter your weight",
                    time: "1 yr",
                    description:
                        "We’ve prepared your weekly health tip to help you improve your mood.",
                    action1: "Add weight entry",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff0D273D),
        selectedItemColor: const Color.fromARGB(255, 202, 231, 255),
        unselectedItemColor: Colors.white,
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainMenuPage()),
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ArticlePage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
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
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String time;
  final String description;
  final String action1;
  final String? action2;

  const NotificationCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.time,
    required this.description,
    required this.action1,
    this.action2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: GoogleFonts.nunito(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.nunito(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  action1,
                  style: GoogleFonts.nunito(
                    color: const Color(0xff0D273D),
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              if (action2 != null)
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    action2!,
                    style: GoogleFonts.nunito(
                      color: const Color(0xff0D273D),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
