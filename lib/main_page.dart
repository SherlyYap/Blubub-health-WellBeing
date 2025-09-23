import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/artikel.dart';
import 'package:project/consultation/consultation.dart';
import 'package:project/fitness/fitness.dart';
import 'package:project/health_food/healthy_food.dart';
import 'package:project/mental_health/self_awareness_page.dart';
import 'consultation/notification.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  String userName = 'Guest';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromARGB(255, 202, 231, 255),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 202, 231, 255),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_circle,
                      size: 48, color: Colors.black),
                  const SizedBox(width: 12),
                  Text(
                    userName,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: Text('Notifications', style: GoogleFonts.nunito()),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Profile', style: GoogleFonts.nunito()),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: Text('Articles', style: GoogleFonts.nunito()),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ArticlePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout', style: GoogleFonts.nunito()),
              onTap: () async {
                bool? confirmLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Konfirmasi Logout',
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                    content: Text('Apakah Anda yakin ingin keluar?',
                        style: GoogleFonts.nunito()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Batal', style: GoogleFonts.nunito()),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Ya, Keluar',
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );

                if (confirmLogout == true) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: 
              Image.asset('img-project/logo.png', height: 100, width: 200),         
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildMenuCard('Fitness', 'img-project/fitness.jpeg',
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FitnessHomePage()),
                );
              }),
              _buildMenuCard('Healthy Food', 'img-project/healthy food.jpeg',
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FoodMenuPage()),
                );
              }),
              _buildMenuCard(
                'Mental Health',
                'img-project/mentalhealth.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SelfAwarenessPage()),
                  );
                },
              ),
              _buildMenuCard(
                'Consultation',
                'img-project/consultation-1.jpeg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => KonsultasiPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, String imagePath, {VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [const Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
              const Positioned(
                right: 12,
                top: 12,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
