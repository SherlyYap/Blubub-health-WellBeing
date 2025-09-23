import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipePage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String rating;

  const RecipePage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.rating,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorited = prefs.getBool('fav_${widget.title}') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorited = !isFavorited;
    });
    await prefs.setBool('fav_${widget.title}', isFavorited);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorited ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit',
          style: GoogleFonts.nunito(),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsedRating = double.tryParse(widget.rating) ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: const Color.fromARGB(255, 202, 231, 255),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(widget.image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 20,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(blurRadius: 4, color: Colors.black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              if (parsedRating >= index + 1) {
                                return const Icon(Icons.star,
                                    color: Colors.amber, size: 20);
                              } else if (parsedRating > index) {
                                return const Icon(Icons.star_half,
                                    color: Colors.amber, size: 20);
                              } else {
                                return const Icon(Icons.star_border,
                                    color: Colors.amber, size: 20);
                              }
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.rating} / 5',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'favorite') {
                    _toggleFavorite();
                  } else if (value == 'share') {
                    Share.share(
                      'Cek resep ini: ${widget.title}\n\nRating: ${widget.rating}/5\n\n${widget.description}',
                      subject: 'Resep: ${widget.title}',
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'favorite',
                    child: ListTile(
                      leading: Icon(
                        isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.pinkAccent,
                      ),
                      title: Text('Favorite', style: GoogleFonts.nunito()),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'share',
                    child: ListTile(
                      leading: const Icon(Icons.share, color: Colors.black),
                      title: Text('Share', style: GoogleFonts.nunito()),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Resep',
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1.2),
                    const SizedBox(height: 10),
                    ..._buildFormattedDescription(widget.description),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormattedDescription(String desc) {
    final lines = desc.split('\n');
    List<Widget> widgets = [];

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      if (line.endsWith(':')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Text(
              line.trim(),
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        );
      } else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              line.trim(),
              style: GoogleFonts.nunito(fontSize: 16),
            ),
          ),
        );
      } else if (line.trim().startsWith('-')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    line.trim().substring(1).trim(),
                    style: GoogleFonts.nunito(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line.trim(),
              style: GoogleFonts.nunito(fontSize: 16, height: 1.5),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
