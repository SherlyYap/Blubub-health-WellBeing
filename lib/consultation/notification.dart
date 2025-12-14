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
    loadNotifications().then((_) => setState(() {}));
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Yakin ingin menghapus semua notifikasi?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await clearNotifications();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua notifikasi berhasil dihapus")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromARGB(255, 202, 231, 255),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16),
                Text(
                  "Notifications",
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ActionChip(
                    backgroundColor: const Color(0xff0D273D),
                    label: Text(
                      "Hapus Semua",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _clearAll,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Expanded(
              child:
                  customNotifications.isEmpty
                      ? Center(
                        child: Text(
                          "Tidak ada notifikasi",
                          style: GoogleFonts.nunito(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: customNotifications.length,
                        itemBuilder: (context, index) {
                          final item = customNotifications[index];

                          return Dismissible(
                            key: Key(item['time'] ?? index.toString()),
                            direction: DismissDirection.endToStart,

                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),

                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text("Hapus Notifikasi"),
                                      content: const Text(
                                        "Apakah kamu yakin ingin menghapus notifikasi ini?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text(
                                            "Hapus",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },

                            onDismissed: (_) async {
                              await deleteNotificationAt(index);
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Notifikasi berhasil dihapus"),
                                ),
                              );
                            },

                            child: NotificationCard(
                              title: item['title'] ?? '',
                              time: item['time'] ?? '',
                              description: item['message'] ?? '',
                              action1: "Lihat Detail",
                            ),
                          );
                        },
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
                MaterialPageRoute(builder: (_) => const MainMenuPage()),
              );
              break;
            case 1:
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Article"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final String action1;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    required this.action1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.orange,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.nunito(fontSize: 12, color: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

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
        ],
     ),
);
}
}
