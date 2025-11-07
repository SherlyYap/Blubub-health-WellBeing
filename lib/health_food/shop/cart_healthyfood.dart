import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _metodeController = TextEditingController();

  Future<void> _simpanPembelian(ShopProvider provider) async {
    if (provider.keranjang.isEmpty) return;

    final int totalHarga = provider.totalHarga();

    final itemsList = provider.keranjang.map((e) {
      return {
        'nama': e.nama,
        'jumlah': e.jumlah,
        'harga': e.harga,
        'total': e.harga * e.jumlah,
      };
    }).toList();

    final String itemsJson = jsonEncode(itemsList);
    final String metode =
        _metodeController.text.isEmpty ? 'Tunai' : _metodeController.text;

    // ✅ Simpan data pembelian ke database lokal
    await BahanDBHelper.insertPurchaseHistory(
      itemsJson,
      totalHarga,
      metode,
    );

    // ✅ Catat event pembayaran ke Firebase Analytics
    await analytics.logAddPaymentInfo(
      paymentType: metode,
      currency: 'IDR',
      value: double.tryParse(totalHarga.toString()) ?? 0.0,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pembelian berhasil dan dicatat di Firebase Analytics!',
          style: GoogleFonts.nunito(),
        ),
      ),
    );

    provider.clearKeranjang();
    Navigator.pop(context);
  }

  void _pilihMetodePembayaran() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final metodeList = ['Tunai', 'QRIS', 'Transfer Bank', 'E-Wallet'];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Metode Pembayaran',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...metodeList.map((metode) {
                return ListTile(
                  title: Text(metode, style: GoogleFonts.nunito(fontSize: 16)),
                  onTap: () {
                    setState(() {
                      _metodeController.text = metode;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang', style: GoogleFonts.nunito()),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      ),
      body: provider.keranjang.isEmpty
          ? Center(
              child: Text(
                'Keranjang masih kosong',
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.keranjang.length,
                    itemBuilder: (context, index) {
                      final item = provider.keranjang[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Image.asset(
                            item.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item.nama,
                            style:
                                GoogleFonts.nunito(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Rp ${item.harga} x ${item.jumlah} = Rp ${item.harga * item.jumlah}',
                            style: GoogleFonts.nunito(),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => provider.kurangiJumlah(item),
                              ),
                              Text(
                                '${item.jumlah}',
                                style: GoogleFonts.nunito(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => provider.tambahJumlah(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pilihMetodePembayaran,
                        icon: const Icon(Icons.credit_card),
                        label: Text(
                          _metodeController.text.isEmpty
                              ? 'Pilih Metode Pembayaran'
                              : 'Metode: ${_metodeController.text}',
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 94, 172),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Total: Rp ${NumberFormat("#,###").format(provider.totalHarga())}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async => await _simpanPembelian(provider),
                        icon: const Icon(Icons.payment),
                        label: Text(
                          'Bayar Sekarang',
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
