import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/database/test_history_db.dart';

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

  List<Map<String, dynamic>> _allResults = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  /// Fungsi untuk memuat hasil tes dari database
  Future<void> _loadResults() async {
    List<Map<String, dynamic>> tempResults = [];

    for (String key in testLabels.keys) {
      final results = await TestHistoryDB.getResults(key);
      if (results.isNotEmpty) {
        final latest = results.first;
        final previous = results.length > 1 ? results[1] : null;

        tempResults.add({
          'type': key,
          'label': testLabels[key],
          'score': latest['score'],
          'date': latest['date'],
          'previousScore': previous?['score'],
        });
      }
    }

    // Urutkan semua hasil global berdasarkan tanggal terbaru
    tempResults.sort((a, b) {
      final aDate = _safeParseDate(a['date']);
      final bDate = _safeParseDate(b['date']);
      return bDate.compareTo(aDate);
    });

    setState(() {
      _allResults = tempResults;
    });
  }

  /// Fungsi aman untuk parsing berbagai format tanggal
  DateTime _safeParseDate(dynamic value) {
    try {
      if (value is DateTime) return value;
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      return DateTime.tryParse(value.toString()) ?? DateTime(1970);
    } catch (_) {
      return DateTime(1970);
    }
  }

  String _formatDate(dynamic value) {
  final date = _safeParseDate(value);
  const bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  final jam = date.hour.toString().padLeft(2, '0');
  final menit = date.minute.toString().padLeft(2, '0');
  return "${date.day} ${bulan[date.month - 1]} ${date.year}, $jam:$menit";
}


  String _interpretScore(int score) {
    if (score <= 2) return "Tingkat Rendah";
    if (score <= 4) return "Tingkat Sedang";
    return "Tingkat Tinggi";
  }

  String _getProgressStatus(int? previous, int current) {
    if (previous == null) return "Data Pertama";
    if (current < previous) return "Membaik";
    if (current > previous) return "Menurun";
    return "Stabil";
  }

  Color _getProgressColor(String status) {
    switch (status) {
      case "Membaik":
        return Colors.green;
      case "Menurun":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double _calculateProgressPercent(int? previous, int current) {
    if (previous == null) return 0.0;
    int diff = previous - current;
    double percent = (diff.abs() / (previous == 0 ? 1 : previous)).clamp(
      0.0,
      1.0,
    );
    return percent;
  }

  Future<void> _clearAllResults() async {
    await TestHistoryDB.clearAll();
    setState(() => _allResults.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua riwayat tes telah dihapus")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAE7FF),
      appBar: AppBar(
        title: Text(
          "Riwayat Tes",
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
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text("Hapus Semua Riwayat?"),
                      content: const Text(
                        "Semua hasil tes akan dihapus permanen dari database.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _clearAllResults();
                          },
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body:
          _allResults.isEmpty
              ? const Center(
                child: Text(
                  "Belum ada hasil tes yang tersimpan.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _allResults.length,
                itemBuilder: (context, index) {
                  final item = _allResults[index];
                  final progressStatus = _getProgressStatus(
                    item['previousScore'],
                    item['score'],
                  );
                  final progressColor = _getProgressColor(progressStatus);
                  final progressValue = _calculateProgressPercent(
                    item['previousScore'],
                    item['score'],
                  );

                  final int? prev = item['previousScore'];
                  final int curr = item['score'];
                  final int diff = prev != null ? curr - prev : 0;

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['label'],
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Tanggal: ${_formatDate(item['date'])}",
                            style: GoogleFonts.nunito(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Skor: ${item['score']} (${_interpretScore(item['score'])})",
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                progressStatus,
                                style: GoogleFonts.nunito(
                                  color: progressColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (prev != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "${diff > 0 ? '+' : ''}$diff poin",
                                style: GoogleFonts.nunito(
                                  color: progressColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.grey.shade300,
                            color: progressColor,
                            minHeight: 6,
                          ),
                          if (item['previousScore'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "Sebelumnya: ${item['previousScore']}",
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
