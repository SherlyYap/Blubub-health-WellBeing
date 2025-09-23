import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  final List<Map<String, String>> _quotes = const [
    {
      "en": "Believe you can and you're halfway there.",
      "id": "Percayalah kamu bisa, dan kamu sudah setengah jalan.",
    },
    {
      "en":
          "Keep your face always toward the sunshine, and shadows will fall behind you.",
      "id":
          "Hadapkan wajahmu selalu ke arah matahari, dan bayangan akan jatuh di belakangmu.",
    },
    {
      "en": "It's okay to not be okay.",
      "id": "Tidak apa-apa untuk tidak merasa baik-baik saja.",
    },
    {
      "en": "Your mental health is a priority.",
      "id": "Kesehatan mentalmu adalah prioritas.",
    },
    {
      "en": "Rest is not a luxury. It's essential.",
      "id": "Istirahat bukanlah kemewahan. Itu penting.",
    },
    {
      "en": "You are not alone. There is help, and there is hope.",
      "id": "Kamu tidak sendirian. Ada bantuan, dan ada harapan.",
    },
    {
      "en": "Healing is not linear.",
      "id": "Penyembuhan tidak selalu berjalan lurus.",
    },
    {
      "en": "Talking about your feelings is a strength, not a weakness.",
      "id": "Berbicara tentang perasaanmu adalah kekuatan, bukan kelemahan.",
    },
    {
      "en":
          "The only limit to our realization of tomorrow is our doubts of today.",
      "id":
          "Satu-satunya batas untuk mewujudkan hari esok adalah keraguan kita hari ini.",
    },
    {
      "en":
          "Success is not the key to happiness. Happiness is the key to success.",
      "id":
          "Kesuksesan bukanlah kunci kebahagiaan. Kebahagiaan adalah kunci kesuksesan.",
    },
    {
      "en":
          "You don’t have to control your thoughts. You just have to stop letting them control you.",
      "id":
          "Kamu tidak harus mengendalikan pikiranmu. Kamu hanya perlu berhenti membiarkannya mengendalikanmu.",
    },
    {
      "en":
          "Sometimes the people around you won’t understand your journey. They don’t need to, it’s not for them.",
      "id":
          "Terkadang orang di sekitarmu tidak akan mengerti perjalananmu. Dan itu tidak masalah, karena itu bukan untuk mereka.",
    },
    {
      "en": "Self-care is how you take your power back.",
      "id": "Perawatan diri adalah cara kamu mengambil kembali kekuatanmu.",
    },
    {
      "en": "You are more than the mistakes you've made.",
      "id": "Kamu lebih dari sekadar kesalahan yang pernah kamu buat.",
    },
    {
      "en": "Small steps every day lead to big changes.",
      "id": "Langkah kecil setiap hari membawa perubahan besar.",
    },
    {
      "en":
          "Taking care of your mental health is a form of strength, not weakness.",
      "id":
          "Merawat kesehatan mentalmu adalah bentuk kekuatan, bukan kelemahan.",
    },
    {
      "en": "Be proud of how hard you’re trying.",
      "id": "Banggalah atas betapa kerasnya kamu berusaha.",
    },
    {
      "en": "You are not a burden. You are a human with emotions.",
      "id": "Kamu bukan beban. Kamu adalah manusia dengan emosi.",
    },
    {
      "en": "Healing takes time, and that's okay.",
      "id": "Penyembuhan membutuhkan waktu, dan itu tidak apa-apa.",
    },
    {
      "en": "You matter. Your story matters. Your feelings matter.",
      "id": "Kamu penting. Ceritamu penting. Perasaanmu penting.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text(
          'Mental Health Quotes',
          style: GoogleFonts.nunito(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount =
                constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 600 ? 3 : 2;

            return MasonryGridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                final quote = _quotes[index];
                final bool isEven = index % 2 == 0;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          title: Text(
                            'Quote Detail',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.format_quote, size: 40, color: Colors.blueGrey),
                              const SizedBox(height: 16),
                              Text(
                                quote['en']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                quote['id']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Close',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isEven ? Colors.white : Colors.lightBlue[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.format_quote, color: Colors.blueGrey, size: 32),
                        const SizedBox(height: 10),
                        Text(
                          quote['en']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          quote['id']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
