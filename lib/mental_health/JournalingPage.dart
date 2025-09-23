import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class JournalEntry {
  String title;
  String content;
  String dateTime;
  Color color;

  JournalEntry({
    required this.title,
    required this.content,
    required this.dateTime,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'dateTime': dateTime,
    'color': color.value,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    title: json['title'],
    content: json['content'],
    dateTime: json['dateTime'],
    color: Color(json['color']),
  );
}

class JournalingPage extends StatefulWidget {
  const JournalingPage({super.key});

  @override
  State<JournalingPage> createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  List<JournalEntry> _journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('journal_entries') ?? [];
    setState(() {
      _journalEntries =
          jsonList.map((e) => JournalEntry.fromJson(json.decode(e))).toList();
    });
  }

  Future<void> _saveJournalEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList =
        _journalEntries.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('journal_entries', jsonList);
  }

  void _addOrEditJournalEntry({JournalEntry? existingEntry, int? index}) {
    final titleController = TextEditingController(
      text: existingEntry?.title ?? '',
    );
    final contentController = TextEditingController(
      text: existingEntry?.content ?? '',
    );
    Color selectedColor = existingEntry?.color ?? Colors.white;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text(
                existingEntry == null
                    ? 'Add Journal Entry'
                    : 'Edit Journal Entry',
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: GoogleFonts.nunito(),
                      ),
                    ),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        labelStyle: GoogleFonts.nunito(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Pick Color:'),
                        const SizedBox(width: 10),
                        Wrap(
                          spacing: 8,
                          children:
                              [
                                Colors.white,
                                Colors.yellow[100]!,
                                Colors.pink[100]!,
                                Colors.green[100]!,
                                Colors.blue[100]!,
                              ].map((color) {
                                return GestureDetector(
                                  onTap: () {
                                    setInnerState(() => selectedColor = color);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: color,
                                    radius: 12,
                                    child:
                                        selectedColor == color
                                            ? const Icon(Icons.check, size: 16)
                                            : null,
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.nunito()),
                ),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final formattedDate =
                        '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                    final newEntry = JournalEntry(
                      title: titleController.text,
                      content: contentController.text,
                      dateTime:
                          '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}',
                      color: selectedColor,
                    );

                    setState(() {
                      if (existingEntry != null && index != null) {
                        _journalEntries[index] = newEntry;
                      } else {
                        _journalEntries.add(newEntry);
                      }
                    });
                    _saveJournalEntries();
                    Navigator.pop(context);
                  },
                  child: Text('Confirm', style: GoogleFonts.nunito()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteJournalEntry(int index) {
    setState(() {
      _journalEntries.removeAt(index);
    });
    _saveJournalEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text(
          'Journaling',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _journalEntries.isEmpty
                ? Center(
                  child: Text(
                    'No journal entries yet. Start adding your thoughts!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                )
                : ListView.builder(
                  itemCount: _journalEntries.length,
                  itemBuilder: (context, index) {
                    final entry = _journalEntries[index];

                    final parts = entry.dateTime.split(' ');
                    final date = parts.length > 0 ? parts[0] : '';
                    final time = parts.length > 1 ? parts[1] : '';

                    return Card(
                      color: entry.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    date,
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  entry.title,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const Divider( thickness: 1, color: Colors.black87,),

                                Text(
                                  entry.content,
                                  style: GoogleFonts.nunito(fontSize: 14),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$time WIB',
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                      ),
                                    ),

                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _addOrEditJournalEntry(
                                            existingEntry: entry,
                                            index: index,
                                          );
                                        } else if (value == 'delete') {
                                          _deleteJournalEntry(index);
                                        }
                                      },
                                      itemBuilder:
                                          (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                      child: const Icon(
                                        Icons.more_vert,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditJournalEntry(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
