import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/consultation/DoctorDetailPage.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/localization/app_localizations.dart';
import 'package:project/main_page.dart';
import 'package:project/consultation/notification.dart';
import '../artikel.dart';
import 'package:provider/provider.dart';
import '../provider/favorite_provider.dart';
import 'package:project/consultation/shop_page.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  State<KonsultasiPage> createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> doctorList = [
    {
      'name': 'Clarrisa',
      'specialist': 'Gizi',
      'hospital': 'RS. Asia Medica',
      'image': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'name': 'Giselle',
      'specialist': 'Nutrisi',
      'hospital': 'RS. Colombia',
      'image': 'https://randomuser.me/api/portraits/women/65.jpg',
    },
    {
      'name': 'Andre',
      'specialist': 'Mental Health',
      'hospital': 'RS. Deli',
      'image': 'https://randomuser.me/api/portraits/men/45.jpg',
    },
    {
      'name': 'Yasmin',
      'specialist': 'Anak',
      'hospital': 'RS. Mitra Keluarga',
      'image': 'https://randomuser.me/api/portraits/women/68.jpg',
    },
    {
      'name': 'Dr. Rizal',
      'specialist': 'Jantung',
      'hospital': 'RS. Harapan Bangsa',
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'name': 'Dr. Linda',
      'specialist': 'Kulit & Kelamin',
      'hospital': 'RS. Estetika Medan',
      'image': 'https://randomuser.me/api/portraits/women/25.jpg',
    },
    {
      'name': 'Dr. Samuel',
      'specialist': 'Saraf',
      'hospital': 'RS. Kasih Ibu',
      'image': 'https://randomuser.me/api/portraits/men/41.jpg',
    },
  ];

  List<Map<String, String>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctorList;
    _searchController.addListener(_filterDoctors);
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors =
          doctorList.where((doctor) {
            final name = doctor['name']!.toLowerCase();
            final specialist = doctor['specialist']!.toLowerCase();
            final hospital = doctor['hospital']!.toLowerCase();
            return name.contains(query) ||
                specialist.contains(query) ||
                hospital.contains(query);
          }).toList();
    });
  }

  void _showFilterDialog() {
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: Text(loc.translate("choose_specialist"), style: GoogleFonts.nunito()),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _filterBySpecialist(null);
                },
                child: Text(loc.translate("all"), style: GoogleFonts.nunito()),
              ),
              ..._getSpecialistList().map((specialist) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    _filterBySpecialist(specialist);
                  },
                  child: Text(specialist, style: GoogleFonts.nunito()),
                );
              }).toList(),
            ],
          ),
    );
  }

  Set<String> _getSpecialistList() {
    return doctorList.map((d) => d['specialist']!).toSet();
  }

  void _filterBySpecialist(String? specialist) {
    setState(() {
      if (specialist == null) {
        filteredDoctors = doctorList;
      } else {
        filteredDoctors =
            doctorList
                .where(
                  (doctor) =>
                      doctor['specialist']!.toLowerCase() ==
                      specialist.toLowerCase(),
                )
                .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 202, 231, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Image.asset('img-project/logo.png', width: 200, height: 150),
          Text(
            loc.translate("medan_doctor"),
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc.translate("search_doctor"),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _showFilterDialog,
            icon: Icon(Icons.filter_list, color: const Color(0xff0D273D)),
            label: Text(
              loc.translate("filter_specialist"),
              style: GoogleFonts.nunito(color: const Color(0xff0D273D)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                final isFavorited = favoriteProvider.isFavorite(
                  doctor['name']!,
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doctor['image']!),
                        radius: 30,
                      ),
                      title: Text(
                        doctor['name']!,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          favoriteProvider.toggleFavorite(doctor);
                        },
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['specialist']!,
                            style: GoogleFonts.nunito(
                              color: const Color(0xff0D273D),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                doctor['hospital']!,
                                style: GoogleFonts.nunito(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            DoctorDetailPage(doctor: doctor),
                                  ),
                                );
                              },
                              child: Text(
                                'selengkapnya',
                                style: GoogleFonts.nunito(
                                  color: const Color(0xff0D273D),
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.translate("home")),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: loc.translate("inbox")),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: loc.translate("article")),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: loc.translate("profile")),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShopPage()),
          );
        },
        backgroundColor: const Color(0xff0D273D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_cart),
        label: Text(loc.translate("online_pharmacy"), style: GoogleFonts.nunito()),
      ),
    );
  }
}
