import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/health_food/shop/history_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:project/provider/shop_provider.dart';
import 'package:project/database/db_bahan_helper.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await BahanDBHelper.getPurchaseHistory();
    setState(() => historyList = data);
  }

  Future<void> _simpanPembelian(ShopProvider provider, String metode) async {
    if (provider.keranjang.isEmpty) return;

    final int totalHarga = provider.totalHarga();
    final itemsList =
        provider.keranjang
            .map(
              (e) => {
                'nama': e.nama,
                'jumlah': e.jumlah,
                'harga': e.harga,
                'total': e.harga * e.jumlah,
              },
            )
            .toList();

    final String itemsJson = jsonEncode(itemsList);
    await BahanDBHelper.insertPurchaseHistory(itemsJson, totalHarga, metode);

    await analytics.logAddPaymentInfo(
      paymentType: metode,
      currency: 'IDR',
      value: double.tryParse(totalHarga.toString()) ?? 0.0,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pembayaran berhasil!',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );

    provider.clearKeranjang();
    _loadHistory();
  }

  void _tampilkanMetodePembayaran(ShopProvider provider) {
    String selectedMethod = "E-Wallet";

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Pilih Metode Pembayaran',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String>(
                      title: const Text('Kartu Kredit'),
                      value: 'Kartu Kredit',
                      groupValue: selectedMethod,
                      onChanged: (val) => setState(() => selectedMethod = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('E-Wallet'),
                      value: 'E-Wallet',
                      groupValue: selectedMethod,
                      onChanged: (val) => setState(() => selectedMethod = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Transfer Bank'),
                      value: 'Transfer Bank',
                      groupValue: selectedMethod,
                      onChanged: (val) => setState(() => selectedMethod = val!),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: GoogleFonts.nunito(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffEAE6FF),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _tampilkanKonfirmasiPesanan(provider, selectedMethod);
                },
                child: Text(
                  'Next',
                  style: GoogleFonts.nunito(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  void _tampilkanKonfirmasiPesanan(ShopProvider provider, String metode) {
    final totalHarga = provider.totalHarga();
    final itemsList = provider.keranjang;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Konfirmasi Pesanan',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in itemsList)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${item.nama}\n${item.jumlah} × Rp ${item.harga}",
                              style: GoogleFonts.nunito(),
                            ),
                          ),
                          Text(
                            "Rp ${item.harga * item.jumlah}",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: Rp $totalHarga",
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Kembali',
                  style: GoogleFonts.nunito(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffEAE6FF),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await _simpanPembelian(provider, metode);
                },
                child: Text(
                  'Bayar',
                  style: GoogleFonts.nunito(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context);
    final total = provider.totalHarga();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffCBE5FF),
        elevation: 0,
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ====== Bagian utama keranjang ======
          provider.keranjang.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Keranjang kamu kosong!",
                      style: GoogleFonts.nunito(fontSize: 16),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Daftar item
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.keranjang.length,
                      itemBuilder: (context, index) {
                        final item = provider.keranjang[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    item.gambar,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Rp ${item.harga} (per ${item.satuan})",
                                        style: GoogleFonts.nunito(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed:
                                          () => provider.kurangiJumlah(item),
                                    ),
                                    Text(
                                      '${item.jumlah}',
                                      style: GoogleFonts.nunito(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed:
                                          () => provider.tambahJumlah(item),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => provider.removeFromKeranjang(
                                            item,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Total pembayaran
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total:",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Rp ${provider.totalHarga()}",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Checkout
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            provider.keranjang.isEmpty
                                ? null
                                : () => _tampilkanMetodePembayaran(provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Checkout Sekarang",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          if (provider.keranjang.isNotEmpty || historyList.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionalTranslation(
                translation: const Offset(
                  0,
                  -2.5,
                ), 
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                  label: Text("Riwayat", style: GoogleFonts.nunito()),
                  icon: const Icon(Icons.receipt_long_rounded,
                  color: Colors.white,),
                  backgroundColor: const Color(0xff0D273D),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
