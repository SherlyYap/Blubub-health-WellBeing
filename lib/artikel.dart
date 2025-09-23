import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/ProfilPage.dart';
import 'package:project/main_page.dart';
import 'package:project/consultation/notification.dart';
import 'ArticleDetailPage.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  final List<Map<String, String>> articles = const [
    {
      'category': 'Hidup Sehat',
      'title': 'Cara Merawat Kulit Wajah yang Baik dan Benar',
      'image': 'https://awsimages.detik.net.id/community/media/visual/2019/10/24/453c1300-a714-49b4-9ab8-760f2f73ea32.jpeg?w=1200',
    },
    {
      'category': 'Kesehatan',
      'title': 'Makin Cantik setelah Tahu Cara Membersihkan Wajah dengan Benar',
      'image': 'https://res.cloudinary.com/dk0z4ums3/image/upload/v1623652646/attached_image/perawatan-wajah-kusam-agar-tampil-lebih-cerah-0-alodokter.jpg',
    },
    {
      'category': 'Kesehatan Mental',
      'title': 'Cara Healing yang cocok untuk introvert agar tak gampang stress',
      'image': 'https://cdn1-production-images-kly.akamaized.net/MJP69y9UBONvwEboVO43yB20lRk=/0x154:3000x1845/500x281/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/4090631/original/047923700_1657944348-rekomendasi_buku_bagus.jpg',
    },
    {
      'category': 'Fitness',
      'title': 'Tips Menghilangkan pegal di kaki dan paha setelah olahraga lari',
      'image': 'https://www.neorheumacyl.com/public/files/Tips-Menghilangkan-Pegal-di-Kaki-dan-Paha-Setelah-Olahraga-Lari.jpg',
    },
    {
      'category': 'Makanan Sehat',
      'title': 'Alasan dan Bahaya Makan Mie Pakai Nasi untuk tubuh',
      'image': 'https://mmc.tirto.id/image/2024/04/05/ilustrasi-makan-mie-pakai-nasi-tirto-01_ratio-16x9.jpg',
    },
    {
      'category': 'Makanan Sehat',
      'title': 'Ini Kriteria Makanan Sehat untuk Anak',
      'image': 'https://www.vidoran.com/public/files/kriteria_makanan_sehat_untuk_anak.jpg',
    },
    {
      'category': 'Hidup Sehat',
      'title': 'Makan Banyak tapi Tetap Kurus? Ini Kemungkinan Penyebabnya',
      'image': '',
    },
    {
      'category': 'Kesehatan Mental',
      'title': 'Cara Mengatasi Overthinking dengan Teknik Pernapasan',
      'image': '',
    },
    {
      'category': 'Kesehatan Mental',
      'title': 'Pentingnya Self-Care untuk Menjaga Kesehatan Mental',
      'image': '',
    },
    {
      'category': 'Kesehatan Mental',
      'title': 'Tips Mengelola Stres di Tengah Kesibukan Sehari-hari',
      'image': '',
    },
    {
      'category': 'Kesehatan Mental',
      'title': 'Kenali Tanda-Tanda Burnout dan Cara Mengatasinya',
      'image': 'https://media.kompas.tv/library/image/content_article/article_img/20210207164102.jpg',
    },
    {
      'category': 'Fitness',
      'title': 'Bukan Cuma Sit Up, ini beberapa latihan untuk membentuk Otot Perut',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRy5jb1iwtKu_0TiflcFG5EMYMIuHJRY4itaWLCAdnIJqvgt9iwjVrpOtfKhSRq2sBMQnU&usqp=CAU',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color.fromARGB(255, 202, 231, 255),
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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: articles.length,
        separatorBuilder: (context, _) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailPageFancy(
                    title: article['title'] ?? '',
                    category: article['category'] ?? '',
                    content:
                        'Ini adalah isi lengkap dari artikel berjudul "${article['title']}". Nanti bisa kamu ganti sesuai kebutuhan.',
                    imageUrl: article['image'] ?? '',
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(25, 0, 0, 0),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: article['image']!.isNotEmpty
                        ? Image.network(
                            article['image']!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 160,
                            color: const Color(0xFFE6F3EB),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 85, 157, 216)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article['category']!,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: const Color(0xff0D273D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article['title']!,
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
          );
        },
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
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
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
