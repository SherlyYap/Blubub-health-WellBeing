import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ArticleDetailPage.dart';
import 'ProfilPage.dart';
import 'main_page.dart';
import 'consultation/notification.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<dynamic> articles = [];
  List<dynamic> filteredArticles = [];
  bool isLoading = true;
  String searchQuery = "";

  final String apiKey = "pub_b47cc92d5b43463fbb6ea6a42eeacb69";

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final urls = [
        "https://newsdata.io/api/1/news?apikey=$apiKey&q=mental%20health%20indonesia&language=id",
        "https://newsdata.io/api/1/news?apikey=$apiKey&q=healthy%20lifestyle%20exercise&language=en",
      ];

      List<dynamic> allArticles = [];

      for (String url in urls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['results'] != null) {
            allArticles.addAll(data['results']);
          }
        }
      }
      final uniqueArticles = <String, dynamic>{};
      for (var article in allArticles) {
        uniqueArticles[article['title'] ?? ''] = article;
      }

      setState(() {
        articles = uniqueArticles.values.toList();
        filteredArticles = articles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching articles: $e");
    }
  }

  void filterArticles(String query) {
    final filtered = articles.where((article) {
      final title = (article['title'] ?? '').toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredArticles = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Colors.black : const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text(
          'Artikel Kesehatan',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchArticles,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: filterArticles,
                      decoration: InputDecoration(
                        hintText: 'Cari artikel...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredArticles.isEmpty
                        ? const Center(
                            child: Text(
                              "Artikel tidak ditemukan.",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            itemCount: filteredArticles.length,
                            separatorBuilder: (context, _) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final article = filteredArticles[index];
                              final imageUrl = article['image_url'] ??
                                  'https://cdn-icons-png.flaticon.com/512/2965/2965879.png';
                              final title = article['title'] ?? 'Tanpa Judul';
                              final source =
                                  article['source_name'] ?? 'Tidak diketahui';
                              final content = article['description'] ??
                                  'Tidak ada deskripsi.';

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ArticleDetailPageFancy(
                                        title: title,
                                        category: source,
                                        content: content,
                                        imageUrl: imageUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(18)),
                                          child: Image.network(
                                            imageUrl,
                                            width: double.infinity,
                                            height: 160,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              height: 160,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image,
                                                  size: 50,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 85, 157, 216)
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  source,
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xff0D273D),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                title,
                                                style: GoogleFonts.nunito(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87,
                                                  height: 1.4,
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
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff0D273D),
        selectedItemColor: Colors.white,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainMenuPage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Article'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
