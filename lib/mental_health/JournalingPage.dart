import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_journaling_helper.dart';

class JournalingPage extends StatefulWidget {
  const JournalingPage({Key? key}) : super(key: key);

  @override
  _JournalingPageState createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _journals = [];

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  Future<void> _refreshJournals() async {
    try {
      await _dbHelper.database; // pastikan database siap
      final data = await _dbHelper.getEntries();
      setState(() {
        _journals = data;
      });
    } catch (e) {
      debugPrint('Gagal memuat data: $e');
    }
  }

  Future<void> _addOrEditJournalEntry({Map<String, dynamic>? existingData}) async {
    final titleController = TextEditingController(
      text: existingData != null ? existingData['title'] : '',
    );
    final contentController = TextEditingController(
      text: existingData != null ? existingData['content'] : '',
    );
    Color selectedColor = existingData != null
        ? Color(existingData['color'])
        : Colors.blue.shade100;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingData == null ? 'Tambah Catatan' : 'Edit Catatan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Isi'),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Warna: "),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      final color = await showDialog<Color>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pilih Warna'),
                          content: Wrap(
                            children: [
                              for (var color in [
                                Colors.blue.shade100,
                                Colors.red.shade100,
                                Colors.green.shade100,
                                Colors.yellow.shade100,
                                Colors.purple.shade100,
                              ])
                                GestureDetector(
                                  onTap: () => Navigator.pop(context, color),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    width: 30,
                                    height: 30,
                                    color: color,
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                      if (color != null) {
                        setState(() => selectedColor = color);
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      color: selectedColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              final dateTime = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

              if (title.isEmpty || content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Judul dan isi tidak boleh kosong')),
                );
                return;
              }

              final data = {
                'title': title,
                'content': content,
                'dateTime': dateTime,
                'color': selectedColor.value,
              };

              try {
                await _dbHelper.database; // pastikan DB sudah siap

                if (existingData == null) {
                  await _dbHelper.insertEntry(data);
                } else {
                  await _dbHelper.updateEntry(existingData['id'], data);
                }

                await _refreshJournals();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                debugPrint('Gagal menyimpan data: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Terjadi kesalahan: $e')),
                );
              }
            },
            child: Text(existingData == null ? 'Simpan' : 'Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteJournalEntry(int id) async {
    try {
      await _dbHelper.database;
      await _dbHelper.deleteEntry(id);
      await _refreshJournals();
    } catch (e) {
      debugPrint('Gagal menghapus data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journaling Harian',
        style: TextStyle(
        color: Colors.white, 
      ),),
        backgroundColor:const Color(0xff0D273D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _journals.isEmpty
          ? const Center(child: Text('Belum ada catatan'))
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) {
                final journal = _journals[index];
                return Card(
                  color: Color(journal['color']),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(journal['title']),
                    subtitle: Text(
                      "${journal['content']}\n${journal['dateTime']}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black87),
                          onPressed: () => _addOrEditJournalEntry(existingData: journal),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteJournalEntry(journal['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditJournalEntry(),
        backgroundColor: const Color(0xff0D273D) ,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          ),
      ),
    );
  }
}
