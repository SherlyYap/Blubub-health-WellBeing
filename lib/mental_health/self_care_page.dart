import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/mental_health/Test_SelfCare/test_question.dart';
import 'package:project/mental_health/Test_SelfCare/test_history_page.dart'; // ✅ pastikan import ini sesuai lokasi file kamu

class SelfCarePage extends StatelessWidget {
  SelfCarePage({super.key});

  final Map<String, String> testLabels = {
    'depression': 'Tes Depresi',
    'anxiety': 'Tes Kecemasan',
    'bipolar': 'Tes Bipolar',
    'ptsd': 'Tes PTSD',
    'addiction': 'Tes Kecanduan',
    'adhd': 'Tes ADHD',
    'stress': 'Tes Stres',
    'sleep': 'Tes Kualitas Tidur',
    'selfesteem': 'Tes Kepercayaan Diri',
    'emotion': 'Tes Kestabilan Emosi',
    'anger': 'Tes Pengendalian Emosi',
    'burnout': 'Tes Burnout',
    'social': 'Tes Kecemasan Sosial',
    'focus': 'Tes Konsentrasi',
    'memory': 'Tes Daya Ingat',
    'energy': 'Tes Energi Harian',
    'relationship': 'Tes Kesehatan Relasi',
    'productivity': 'Tes Produktivitas',
    'mindfulness': 'Tes Mindfulness',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAE7FF),
      appBar: AppBar(
        title: Text(
          "Self Care Test",
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFCAE7FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            tooltip: 'Lihat Riwayat Tes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TestHistoryPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: testLabels.length,
        itemBuilder: (context, index) {
          final key = testLabels.keys.elementAt(index);
          final label = testLabels[key]!;
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              title: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TestQuestionPage(
                      testType: key,
                      testLabel: label,
                    ),
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
