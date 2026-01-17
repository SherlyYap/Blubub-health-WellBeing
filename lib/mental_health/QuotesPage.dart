import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List<Map<String, String>> _quotes = [];
  bool _isLoading = true;
  String? _error;

  RewardedAd? _rewardedAd;
  bool _isPremiumUnlocked = false;

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) return;

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        setState(() {
          _isPremiumUnlocked = true;
        });
      },
    );

    _rewardedAd = null;
    _loadRewardedAd();
  }

  Future<void> _fetchQuotes() async {
    try {
      final response =
          await http.get(Uri.parse('https://zenquotes.io/api/quotes'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          _quotes = jsonResponse
              .map((q) => {
                    'en': q['q'].toString(),
                    'id': q['a'].toString(),
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        _error = 'Gagal mengambil data';
        _isLoading = false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(
        title: Text(
          'All Quotes',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFE6F0FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Quote Premium 🔒',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isPremiumUnlocked
                        ? Text(
                            '“Kesuksesan adalah hasil dari konsistensi kecil setiap hari.”',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _showRewardedAd,
                            child: const Text('Tonton Iklan'),
                          ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MasonryGridView.count(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 900
                                  ? 4
                                  : MediaQuery.of(context).size.width > 600
                                      ? 3
                                      : 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount: _quotes.length,
                          itemBuilder: (context, index) {
                            final quote = _quotes[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.format_quote),
                                  const SizedBox(height: 8),
                                  Text(
                                    quote['en']!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '- ${quote['id']}',
                                    style: GoogleFonts.nunito(fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
