import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YogaPage extends StatefulWidget {
  const YogaPage({super.key});

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
  String searchQuery = '';
  String selectedCategory = 'All';
  DateTime? globalYogaSchedule;
  List<dynamic> yogaList = [];
  bool isLoading = true;

  final List<String> categories = ['All', 'Beginner', 'Intermediate', 'Expert'];

  @override
  void initState() {
    super.initState();
    loadYogaSchedule();
    fetchYogaData(); 
  }

  Future<void> fetchYogaData({String? level}) async {
    setState(() {
      isLoading = true;
    });

    String url = 'https://yoga-api-nzy4.onrender.com/v1/poses';
    if (level != null && level.toLowerCase() != 'all') {
      url = 'https://yoga-api-nzy4.onrender.com/v1/poses?level=${level.toLowerCase()}';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> flatList = [];
        if (data is List) {
          for (var el in data) {
            if (el is Map && el.containsKey('poses') && el['poses'] is List) {
              flatList.addAll(el['poses']);
            } else {
              flatList.add(el);
            }
          }
        } else if (data is Map && data.containsKey('poses')) {
          flatList = data['poses'];
        }

        setState(() {
          yogaList = flatList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load yoga poses');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching yoga data: $e");
    }
  }

  Future<void> saveYogaSchedule(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('yoga_schedule', dateTime.toIso8601String());
  }

  Future<void> loadYogaSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('yoga_schedule');
    if (stored != null) {
      setState(() {
        globalYogaSchedule = DateTime.tryParse(stored);
      });
    }
  }

  List<dynamic> get filteredList {
    if (searchQuery.isEmpty) return yogaList;
    return yogaList
        .where((pose) =>
            (pose['english_name'] ?? '')
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (pose['sanskrit_name_adapted'] ?? '')
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yoga',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 202, 231, 255)),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari gerakan yoga...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCategory,
                    underline: const SizedBox(),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                        fetchYogaData(level: newValue);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: GestureDetector(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        final combinedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        setState(() {
                          globalYogaSchedule = combinedDateTime;
                        });

                        await saveYogaSchedule(combinedDateTime);
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.date_range, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        'Atur Jadwal Yoga',
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (globalYogaSchedule != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    'Jadwal Yoga: ${DateFormat('EEEE, dd MMMM yyyy – hh:mm a').format(globalYogaSchedule!)}',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredList.isEmpty
                        ? Center(
                            child: Text(
                              "Tidak ada pose ditemukan 😅",
                              style: GoogleFonts.nunito(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return Card(
                                margin: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        item['url_png'] ??
                                            item['url_svg'] ??
                                            'https://via.placeholder.com/300',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['english_name'] ?? 'Unknown Pose',
                                            style: GoogleFonts.nunito(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Level: ${item['difficulty_level'] ?? selectedCategory}',
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item['pose_description'] ??
                                                'Tidak ada deskripsi tersedia.',
                                            style: GoogleFonts.nunito(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
