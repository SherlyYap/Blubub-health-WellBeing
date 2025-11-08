import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WorkoutSessionPage.dart';

class HomeWorkoutPage extends StatefulWidget {
  const HomeWorkoutPage({super.key});

  @override
  State<HomeWorkoutPage> createState() => _HomeWorkoutPageState();
}

class _HomeWorkoutPageState extends State<HomeWorkoutPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";
  double _duration = 30;

  List<dynamic> workouts = [];
  bool isLoading = true;
  String? errorMessage;

  final List<String> categories = ["All", "Strength", "Core", "Legs", "Cardio"];

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    const String url =
        "https://www.exercisedb.dev/api/v1/equipments/body%20weight/exercises?offset=0&limit=50";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          workouts = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal memuat data. Kode: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan: $e";
        isLoading = false;
      });
    }
  }
  List<dynamic> get filteredWorkouts {
    final query = _searchController.text.toLowerCase();

    return workouts.where((w) {
      final name = (w['name'] ?? '').toLowerCase();
      final target =
          (w['targetMuscles'] != null && w['targetMuscles'].isNotEmpty)
              ? w['targetMuscles'][0].toString().toLowerCase()
              : '';
      bool matchesCategory = true;
      if (_selectedCategory != "All") {
        if (_selectedCategory == "Strength") {
          matchesCategory =
              target.contains("pectorals") ||
              target.contains("triceps") ||
              target.contains("biceps") ||
              target.contains("shoulders");
        } else if (_selectedCategory == "Core") {
          matchesCategory =
              target.contains("abs") || target.contains("abdominals");
        } else if (_selectedCategory == "Legs") {
          matchesCategory =
              target.contains("legs") ||
              target.contains("glutes") ||
              target.contains("quads");
        } else if (_selectedCategory == "Cardio") {
          matchesCategory =
              target.contains("cardio") || target.contains("calves");
        }
      }

      return name.contains(query) && matchesCategory;
    }).toList();
  }

  void _showWorkoutDetail(dynamic workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  workout["gifUrl"] ?? "",
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                workout["name"] ?? "Unknown",
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Target: ${(workout['targetMuscles'] != null && workout['targetMuscles'].isNotEmpty) ? workout['targetMuscles'][0] : 'N/A'}",
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              Text(
                "Equipment: ${(workout['equipments'] != null && workout['equipments'].isNotEmpty) ? workout['equipments'][0] : 'N/A'}",
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Text(
                "Durasi latihan: ${_duration.round()} menit",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAnalytics.instance.logEvent(
                    name: 'mulai_latihan',
                    parameters: {
                      'workout_name': workout["name"] ?? "Workout",
                      'target_muscle':
                          (workout['targetMuscles'] != null &&
                                  workout['targetMuscles'].isNotEmpty)
                              ? workout['targetMuscles'][0]
                              : 'N/A',
                      'duration_minutes': _duration.round(),
                      'category': _selectedCategory,
                    },
                  );
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WorkoutSessionPage(
                            workoutName: workout["name"] ?? "Workout",
                            workoutImage: workout["gifUrl"] ?? "",
                            workoutDescription:
                                "Target: ${(workout['targetMuscles'] != null && workout['targetMuscles'].isNotEmpty) ? workout['targetMuscles'][0] : 'N/A'}",
                            duration: _duration.round(),
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Mulai Latihan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D273D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text(
          'Home Workout',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Cari latihan...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintStyle: GoogleFonts.nunito(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: GoogleFonts.nunito(color: Colors.black),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final selected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              selectedColor: const Color(0xff0D273D),
                              backgroundColor: Colors.white,
                              labelStyle: GoogleFonts.nunito(
                                color: selected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Durasi Latihan:",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_duration.round()} menit",
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                      ],
                    ),
                    Slider(
                      value: _duration,
                      min: 10,
                      max: 60,
                      divisions: 10,
                      label: "${_duration.round()} menit",
                      activeColor: const Color(0xff0D273D),
                      onChanged: (value) {
                        setState(() {
                          _duration = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        itemCount: filteredWorkouts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          final workout = filteredWorkouts[index];
                          return GestureDetector(
                            onTap: () => _showWorkoutDetail(workout),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      workout["gifUrl"] ?? "",
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: double.infinity,
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.broken_image,
                                            size: 80,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  workout["name"] ?? "Workout",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
              ),
    );
  }
}
