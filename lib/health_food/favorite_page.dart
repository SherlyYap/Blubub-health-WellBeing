import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/health_food/recipe_page.dart';

class FavoriteRecipesDrawer extends StatefulWidget {
  const FavoriteRecipesDrawer({super.key});

  @override
  State<FavoriteRecipesDrawer> createState() => _FavoriteRecipesDrawerState();
}

class _FavoriteRecipesDrawerState extends State<FavoriteRecipesDrawer> {
  List<String> favoriteTitles = [];
  List<Map<String, dynamic>> foods = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadFoods();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final favs = keys
        .where((key) => key.startsWith('fav_') && prefs.getBool(key) == true)
        .map((key) => key.substring(4))
        .toList();

    setState(() {
      favoriteTitles = favs;
    });
  }

  Future<void> _loadFoods() async {
    final String jsonString = await rootBundle.loadString('assets/food.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      foods = jsonData.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20, bottom: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff0D273D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Resep Favorit',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: favoriteTitles.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada resep favorit.',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: favoriteTitles.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final title = favoriteTitles[index];
                      final food = foods.firstWhere(
                        (f) => f['title'] == title,
                        orElse: () => {},
                      );

                      if (food.isEmpty) return const SizedBox.shrink();

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(food['image'] ?? ''),
                        ),
                        title: Text(
                          food['title'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              food['category'] ?? '',
                              style: GoogleFonts.nunito(fontSize: 13),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            Text(
                              food['rating']?.toString() ?? '0.0',
                              style: GoogleFonts.nunito(fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipePage(
                                title: food['title'] ?? '',
                                image: food['image'] ?? '',
                                description: food['description'] ?? '',
                                rating: food['rating']?.toString() ?? '0.0',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
