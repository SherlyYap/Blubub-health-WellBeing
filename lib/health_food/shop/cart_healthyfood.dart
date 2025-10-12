import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/health_food/shop/shop_page.dart';
import 'package:project/health_food/shop/history_page.dart';
import 'package:project/provider/shop_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        title: Text('Shopping Cart', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xffCAE7FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ShopProvider>(
        builder: (context, provider, child) {
          final cartItems = provider.keranjang;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('Keranjang kamu kosong!', style: GoogleFonts.nunito(fontSize: 16)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(item.gambar, width: 55, height: 55, fit: BoxFit.cover),
                        ),
                        title: Text(item.nama, style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rp ${item.harga} (${item.satuan})',
                                style: GoogleFonts.nunito(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.blueGrey),
                                  onPressed: () => provider.kurangJumlah(item),
                                ),
                                Text('${item.jumlah}',
                                    style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                  onPressed: () => provider.tambahJumlah(item),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => provider.removeFromKeranjang(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:',
                            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Rp ${provider.totalHarga()}',
                            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PaymentDialog(totalHarga: provider.totalHarga()),
                          );
                        },
                        child: Text('Checkout Sekarang',
                            style: GoogleFonts.nunito(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xff0D273D),
          icon: const Icon(Icons.receipt_long_rounded, color: Colors.white),
          label: Text('Riwayat', style: GoogleFonts.nunito(color: Colors.white)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
          },
        ),
      ),
    );
  }
}

// =================== Payment Dialog ===================
class PaymentDialog extends StatefulWidget {
  final int totalHarga;
  const PaymentDialog({super.key, required this.totalHarga});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? _selectedPaymentMethod;
  int _step = 1;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context, listen: false);
    final cartItems = provider.keranjang;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      title: Text(_step == 1 ? 'Pilih Metode Pembayaran' : 'Konfirmasi Pesanan',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
      content: _step == 1
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text('Kartu Kredit', style: GoogleFonts.nunito()),
                  value: 'Kartu Kredit',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value),
                ),
                RadioListTile<String>(
                  title: Text('E-Wallet', style: GoogleFonts.nunito()),
                  value: 'E-Wallet',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value),
                ),
                RadioListTile<String>(
                  title: Text('Transfer Bank', style: GoogleFonts.nunito()),
                  value: 'Transfer Bank',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value),
                ),
              ],
            )
          : SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...cartItems.map(
                      (item) => ListTile(
                        title: Text(item.nama, style: GoogleFonts.nunito()),
                        subtitle: Text('${item.jumlah} x Rp ${item.harga}',
                            style: GoogleFonts.nunito(fontSize: 14)),
                        trailing: Text('Rp ${item.jumlah * item.harga}',
                            style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Divider(thickness: 1),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Total: Rp ${widget.totalHarga}',
                          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
      actions: _step == 1
          ? [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
              ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () => setState(() => _step = 2),
                child: const Text('Next'),
              ),
            ]
          : [
              TextButton(
                  onPressed: () => setState(() => _step = 1),
                  child: const Text('Kembali')),
              ElevatedButton(
                onPressed: () async {
                  await provider.checkout(_selectedPaymentMethod!);
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const ShopPage()),
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pembayaran via $_selectedPaymentMethod berhasil!',
                            style: GoogleFonts.nunito()),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Bayar'),
              ),
            ],
    );
  }
}
