import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FatBurnPage extends StatelessWidget {
  const FatBurnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> workouts = [
      {
        "name": "Jumping Jacks",
        "description": "Latihan kardio untuk pemanasan dan membakar kalori."
      },
      {
        "name": "Mountain Climbers",
        "description": "Latihan intensitas tinggi untuk membakar lemak perut."
      },
      {
        "name": "Burpees",
        "description": "Latihan seluruh tubuh untuk meningkatkan daya tahan."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fat Burn Workout',
          style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255) ,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 202, 231, 255),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            final name = workout["name"] ?? "Tanpa Nama";
            final description = workout["description"] ?? "Tidak ada deskripsi.";

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Icon(Icons.fitness_center, color: Colors.green.shade700),
                title: Text(
                  name,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(description),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(name),
                      content: Text(description),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Tutup", style: GoogleFonts.nunito()),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}