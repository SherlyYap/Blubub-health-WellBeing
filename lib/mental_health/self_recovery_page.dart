import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/mental_health/JournalingPage.dart';
import 'package:project/mental_health/QuotesPage.dart';
import 'package:project/main_page.dart';
import 'package:project/artikel.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/mental_health/music.dart';
import 'package:project/consultation/notification.dart';

class SelfRecoveryPage extends StatelessWidget {
  const SelfRecoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text(
          'Self-Recovery',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MenuItem(
            title: 'Journaling',
            subtitle: 'Be Kind To Your Mind',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JournalingPage()),
              );
            },
          ),
          MenuItem(
            title: 'Need Some Quotes?',
            subtitle: 'You Are Not Alone',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuotesPage()),
              );
            },
          ),
          MenuItem(
            title: 'Listen To Your Music Now',
            subtitle: 'FOLLOW YOUR HEART',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MusicPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
                MaterialPageRoute(builder: (context) => const MainMenuPage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
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

class MenuItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const MenuItem({super.key, required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF294A63),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
