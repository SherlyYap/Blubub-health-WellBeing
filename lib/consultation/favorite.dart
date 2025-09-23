import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'DoctorDetailPage.dart';
import '../provider/favorite_provider.dart';

class FavoriteDoctorsPage extends StatelessWidget {
  const FavoriteDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteDoctors = Provider.of<FavoriteProvider>(context).favoriteDoctors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Doctors",
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xff0D273D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      body: favoriteDoctors.isEmpty
          ? Center(
              child: Text(
                "Belum ada dokter yang disukai.",
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: favoriteDoctors.length,
              itemBuilder: (context, index) {
                final doctor = favoriteDoctors[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doctor['image']!),
                      radius: 30,
                    ),
                    title: Text(
                      doctor['name']!,
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['specialist']!,
                            style: GoogleFonts.nunito(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_pin, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                doctor['hospital']!,
                                style: GoogleFonts.nunito(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDetailPage(doctor: doctor),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
