import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/artikel.dart';
import 'package:project/main_page.dart';
import 'package:project/consultation/notification_data.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    loadNotifications().then((_) {
      setState(() {});
    });
  }

  Future<void> _clearAllNotifications() async {
    await clearNotifications();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah dihapus'),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16),
                Text(
                  'Notifications',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ActionChip(
                    label: Text(
                      "Hapus Semua",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: const Color(0xff0D273D),
                    onPressed: _clearAllNotifications,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: customNotifications.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada notifikasi',
                        style: GoogleFonts.nunito(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        for (var notif in customNotifications)
                          NotificationCard(
                            emoji: notif['emoji'] ?? '🔔',
                            title: notif['title'] ?? '',
                            time: notif['time'] ?? '',
                            description: notif['message'] ?? '',
                            action1: "Lihat Detail",
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
