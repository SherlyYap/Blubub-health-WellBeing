import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project/artikel.dart';
import 'package:project/editprofile.dart';
import 'package:project/main_page.dart';
import 'package:project/consultation/notification.dart';
import 'package:project/onboarding.dart';
import 'consultation/favorite.dart';

import 'localization/locale_provider.dart';
import 'localization/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('loggedInName') ?? 'Guest';
      userEmail = prefs.getString('loggedInEmail') ?? 'No email';
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.translate('profile'),
          style: GoogleFonts.nunito(
            color: const Color(0xff0D273D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 16),

          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),

          const SizedBox(height: 12),

          Text(
            userName,
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            userEmail,
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54),
          ),

          const SizedBox(height: 16),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: localeProvider.locale,
                  icon: const Icon(Icons.language),
                  onChanged: (Locale? locale) {
                    if (locale != null) {
                      localeProvider.setLocale(locale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('id'),
                      child: Text('Indonesia'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('es'),
                      child: Text('Español'),
                    ),
                    DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                    DropdownMenuItem(value: Locale('ja'), child: Text('日本')),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileOption(
                  context,
                  icon: Icons.edit,
                  title: loc.translate('edit_profile'),
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.favorite_border,
                  title: loc.translate('favorites'),
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.logout,
                  title: loc.translate('logout'),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff0D273D),
        selectedItemColor: Colors.white,
        currentIndex: 3,
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
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: loc.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mail),
            label: loc.translate('inbox'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.article),
            label: loc.translate('article'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: loc.translate('profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final loc = AppLocalizations.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff0D273D)),
        title: Text(
          title,
          style: GoogleFonts.nunito(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          if (title == loc.translate('logout')) {
            final confirm = await showDialog<bool>(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: Text(loc.translate('logout_confirm')),
                    content: Text(loc.translate('logout_message')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(loc.translate('cancel')),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(loc.translate('yes_logout')),
                      ),
                    ],
                  ),
            );

            if (confirm == true) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await prefs.setBool('isLoggedIn', false);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (route) => false,
              );
            }
          } else if (title == loc.translate('favorites')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoriteDoctorsPage()),
            );
          } else if (title == loc.translate('edit_profile')) {
            final newUsername = await Navigator.push<String>(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );

            if (newUsername != null && newUsername.isNotEmpty) {
              setState(() => userName = newUsername);
            }
          }
        },
      ),
    );
  }
}
