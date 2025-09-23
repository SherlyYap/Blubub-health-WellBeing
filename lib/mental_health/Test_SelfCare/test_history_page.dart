import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class TestHistoryPage extends StatefulWidget {
  const TestHistoryPage({super.key});

  @override
  State<TestHistoryPage> createState() => _TestHistoryPageState();
}

class _TestHistoryPageState extends State<TestHistoryPage> {
  final Map<String, String> testLabels = {
    'depression': 'Tes Depresi',
    'anxiety': 'Tes Kecemasan',
    'bipolar': 'Tes Bipolar',
    'ptsd': 'Tes PTSD',
    'addiction': 'Tes Kecanduan',
    'adhd': 'Tes ADHD',
  };

  Map<String, Map<String, String>> testResults = {};

  @override
  void initState() {
    super.initState();
    _loadAllResults();
  }

  Future<void> _loadAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, Map<String, String>> results = {};

    for (String key in testLabels.keys) {
      final score = prefs.getInt('${key}_score');
      final date = prefs.getString('${key}_date');

      String resultText;
      if (score == null) {
        resultText = 'Belum ada';
      } else if (score <= 2) {
        resultText = 'Tingkat rendah';
      } else if (score <= 4) {
        resultText = 'Tingkat sedang';
      } else {
        resultText = 'Tingkat tinggi';
      }

      results[key] = {
        'result': score == null ? 'Belum ada' : resultText,
        'date': date ?? 'Belum ada',
      };
    }

    setState(() {
      testResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Tes",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: testLabels.length,
        itemBuilder: (context, index) {
          final key = testLabels.keys.elementAt(index);
          final label = testLabels[key]!;
          final result = testResults[key]?['result'] ?? 'Memuat...';
          final date = testResults[key]?['date'] ?? 'Memuat...';

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.health_and_safety, color: Colors.teal),
              title: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Hasil: $result\nTanggal: $date",
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
