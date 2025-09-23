import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YogaPage extends StatefulWidget {
  const YogaPage({super.key});

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
  String searchQuery = '';
  String selectedCategory = 'All';

  DateTime? globalYogaSchedule;

  final List<Map<String, String>> yogaList = [
    {
      'name': 'Chaturanga',
      'image': 'img-project/chaturanga.jpg',
      'desc':
          'Dari posisi plank, turunkan tubuh ke bawah dengan siku menempel di sisi tubuh.',
      'category': 'Strength',
    },
    {
      'name': 'Downward facing Dog',
      'image': 'img-project/downward_dog.jpg',
      'desc':
          'Posisikan tubuh seperti segitiga terbalik, kaki dan tangan menempel di lantai.',
      'category': 'Stretching',
    },
    {
      'name': 'Warrior II',
      'image': 'img-project/warrior_2.jpg',
      'desc':
          'Posisikan tubuh dengan satu kaki di depan dan satu kaki di belakang, tangan terbuka lebar.',
      'category': 'Strength',
    },
    {
      'name': 'Lotus Pose',
      'image': 'img-project/lotus_pose.jpg',
      'desc':
          'Duduk bersila dengan telapak kaki menghadap ke atas dan tangan di pangkuan.',
      'category': 'Stretching',
    },
    {
      'name': 'Cobra Pose',
      'image': 'img-project/cobra_pose.jpg',
      'desc': 'Berbaring telungkup, angkat dada dan kepala dengan tangan.',
      'category': 'Stretching',
    },
    {
      'name': 'Bridge Pose',
      'image': 'img-project/bridge_pose.jpg',
      'desc': 'Berbaring telentang, angkat pinggul ke atas.',
      'category': 'Strength',
    },
    {
      'name': 'Child Pose',
      'image': 'img-project/child_pose.jpg',
      'desc':
          'Duduk di atas tumit, tekuk tubuh ke depan dengan tangan lurus ke depan.',
      'category': 'Stretching',
    },
    {
      'name': 'Tree Pose',
      'image': 'img-project/tree_pose.jpg',
      'desc': 'Satu kaki di paha dalam, tangan di atas kepala.',
      'category': 'Balance',
    },
    {
      'name': 'Warrior I',
      'image': 'img-project/warrior_1.jpg',
      'desc':
          'Posisikan tubuh dengan satu kaki di depan dan satu kaki di belakang, tangan di atas kepala.',
      'category': 'Strength',
    },
    {
      'name': 'Triangle Pose',
      'image': 'img-project/triangle_pose.jpg',
      'desc':
          'Satu kaki di depan, satu kaki di belakang, tangan terbuka lebar.',
      'category': 'Stretching',
    },
    {
      'name': 'Plank Pose',
      'image': 'img-project/plank_pose.jpg',
      'desc': 'Posisi tubuh seperti papan, tangan dan kaki menempel di lantai.',
      'category': 'Strength',
    },
    {
      'name': 'Cow Pose',
      'image': 'img-project/cow_pose.jpg',
      'desc': 'Posisi merangkak, gerakan punggung ke bawah.',
      'category': 'Warm Up',
    },
    {
      'name': 'Seated Forward Bend',
      'image': 'img-project/seated_forward_bend.jpg',
      'desc': 'Duduk dengan kaki lurus, tekuk tubuh ke depan.',
      'category': 'Stretching',
    },
    {
      'name': 'Pigeon Pose',
      'image': 'img-project/pigeon_pose.jpg',
      'desc':
          'Satu kaki di depan, satu kaki di belakang, tubuh condong ke depan.',
      'category': 'Stretching',
    },
    {
      'name': 'Boat Pose',
      'image': 'img-project/boat_pose.jpg',
      'desc': 'Duduk dengan kaki diangkat, tubuh membentuk huruf V.',
      'category': 'Strength',
    },
    {
      'name': 'Happy Baby Pose',
      'image': 'img-project/happybaby_pose.jpg',
      'desc': 'Berbaring telentang, angkat kaki dan pegang telapak kaki.',
      'category': 'Stretching',
    },
    {
      'name': 'Corpse Pose',
      'image': 'img-project/corpse_pose.jpg',
      'desc': 'Berbaring telentang, rilekskan seluruh tubuh.',
      'category': 'Stretching',
    },
    {
      'name': 'Side Plank',
      'image': 'img-project/side_plank.jpg',
      'desc':
          'Posisi tubuh miring, satu tangan dan satu kaki menempel di lantai.',
      'category': 'Strength',
    },
    {
      'name': 'Eagle Pose',
      'image': 'img-project/eagle_pose.jpg',
      'desc':
          'Satu kaki di depan, satu kaki di belakang, tangan saling melilit.',
      'category': 'Balance',
    },
    {
      'name': 'Fish Pose',
      'image': 'img-project/fish_pose.jpg',
      'desc': 'Berbaring telentang, angkat dada dan kepala.',
      'category': 'Stretching',
    },
    {
      'name': 'Table top pose',
      'image': 'img-project/table_top.jpg',
      'desc': 'Posisi merangkak, perut tubuh lurus seperti meja.',
      'category': 'Warm Up',
    },
    {
      'name': 'seated twist right side',
      'image': 'img-project/s_t_r.jpg',
      'desc':
          'Duduk dengan kaki kanan di silangkan ke kiri, kaki kiri di tekuk dan diposisikan di kanan , tubuh berputar ke kanan.',
      'category': 'Warm Up',
    },
    {
      'name': 'cat pose',
      'image': 'img-project/cat_pose.jpg',
      'desc': 'Posisi merangkak, gerakan punggung ke atas.',
      'category': 'Warm Up',
    },
    {
      'name': 'seated twist left side',
      'image': 'img-project/s_t_l.jpg',
      'desc':
          'Duduk dengan kaki kiri di silangkan ke kanan, kaki kanan di tekuk dan diposisikan di kiri , tubuh berputar ke kiri.',
      'category': 'Warm Up',
    },
    {
      'name': 'half moon pose',
      'image': 'img-project/half_moon_pose.jpg',
      'desc':
          'Posisi berdiri dengan satu kaki di depan, satu kaki di belakang, tubuh condong ke samping.',
      'category': 'Balance',
    },
  ];

  final List<String> categories = [
    'All',
    'Warm Up',
    'Strength',
    'Stretching',
    'Balance',
  ];
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

  List<Map<String, String>> get filteredList {
    return yogaList.where((pose) {
      final matchCategory =
          selectedCategory == 'All' || pose['category'] == selectedCategory;
      final matchSearch = pose['name']!.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadYogaSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Text(
              'Yoga',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
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
                    hintStyle: GoogleFonts.nunito(),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ).withOpacity(0.9),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children:
                      categories.map((category) {
                        final isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            selectedColor: const Color(0xff0D273D),
                            backgroundColor: Colors.white70,
                            labelStyle: GoogleFonts.nunito(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
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
                      Icon(
                        Icons.date_range,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Atur Jadwal Yoga',
                        style: GoogleFonts.nunito(
                          color: Color.fromARGB(255, 0, 0, 0),
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
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              Expanded(
                child: ListView.builder(
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
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: GoogleFonts.nunito(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['desc']!,
                                  style: GoogleFonts.nunito(),
                                ),
                                const SizedBox(height: 12),
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
