import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, String>> cartItems;
  final VoidCallback onOrderComplete;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onOrderComplete,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, String>> items = [];

  @override
  void initState() {
    super.initState();
    items = widget.cartItems;
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Konfirmasi Pesanan', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin ingin memesan barang ini?', style: GoogleFonts.nunito()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Batal', style: GoogleFonts.nunito()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0D273D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                showLoadingAndSuccess();
              },
              child: Text('Ya, Pesan', style: GoogleFonts.nunito(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showLoadingAndSuccess() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xff0D273D)),
                const SizedBox(height: 16),
                Text("Memproses pesanan...", style: GoogleFonts.nunito(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.of(context).pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Color(0xff0D273D), size: 64),
                const SizedBox(height: 16),
                Text("Pesanan berhasil!", style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Barang telah dipesan!', style: GoogleFonts.nunito()),
        duration: const Duration(seconds: 2),
      ),
    );

    widget.onOrderComplete();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja', style: GoogleFonts.nunito(color: const Color(0xff0D273D), fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        iconTheme: const IconThemeData(color: Color(0xff0D273D)),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('Keranjang Anda kosong.', style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.medical_services, color: Color(0xff0D273D)),
                          title: Text(item['name']!, style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                          subtitle: Text(item['price']!, style: GoogleFonts.nunito()),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: showConfirmationDialog,
                        label: Text('Pesan Sekarang', style: GoogleFonts.nunito(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
