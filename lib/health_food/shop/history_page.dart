import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/database/db_bahan_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await BahanDBHelper.getPurchaseHistory();
    setState(() => historyList = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pembelian')),
      body: historyList.isEmpty
          ? const Center(child: Text('Belum ada riwayat pembelian'))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                final itemsList = jsonDecode(item['items']) as List;
                final tanggal =
                    DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(item['tanggal']));
                final metode = item['metode'] ?? '-';

                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: $tanggal', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Metode: $metode', style: GoogleFonts.nunito(fontSize: 14)),
                        const Divider(),
                        ...itemsList.map((e) => Text('- ${e['nama']} (${e['jumlah']}x) = Rp${e['total']}')),
                        const Divider(),
                        Text('Total: Rp${item['total']}',
                            style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
