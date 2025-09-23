import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:project/health_food/recipe_page.dart';
import 'package:project/health_food/models/food.dart'; 

class Top3Health extends StatefulWidget {
  const Top3Health({super.key});

  @override
  State<Top3Health> createState() => _Top3HealthState();
}

class _Top3HealthState extends State<Top3Health> {
  List<Food> _top3Foods = [];

  @override
  void initState() {
    super.initState();
    _loadRandomTop3Foods();
  }

  Future<void> _loadRandomTop3Foods() async {
    final String jsonString = await rootBundle.loadString('assets/food.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Food> allFoods =
        jsonList.map((json) => Food.fromJson(json)).toList();

    allFoods.shuffle(Random()); 
    setState(() {
      _top3Foods = allFoods.take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xff0D273D),
        title: Text(
          'Top 3 Health Menus',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _top3Foods.isEmpty
          ? Center(
              child: Text(
                "Loading...",
                style: GoogleFonts.nunito(fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Today\'s Top 3 Healthy Menus!',
                            style: GoogleFonts.nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff0D273D),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'img-project/fruit.png',
                          height: 80,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 80),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (var food in _top3Foods)
                    buildMenuItem(
                      context,
                      imagePath: food.image,
                      title: food.title,
                      shortDescription: food.category,
                      fullDescription: food.description,
                      rating: food.rating.toString(),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget buildMenuItem(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String shortDescription,
    required String fullDescription,
    required String rating,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipePage(
              title: title,
              image: imagePath,
              description: fullDescription,
              rating: rating,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shortDescription,
                      style: GoogleFonts.nunito(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
