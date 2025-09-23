import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/health_food/shop/shop_page.dart';
import 'package:project/provider/shop_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart', style: GoogleFonts.nunito()),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ShopProvider>(
        builder: (context, provider, child) {
          final cartItems = provider.keranjang;

          if (cartItems.isEmpty) {
            return Center(
              child: Text(
                'Keranjang kamu kosong!',
                style: GoogleFonts.nunito(fontSize: 16),
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
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Image.asset(
                          item.gambar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.nama, style: GoogleFonts.nunito()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rp ${item.harga} (${item.satuan})',
                              style: GoogleFonts.nunito(fontSize: 14),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => provider.kurangJumlah(item),
                                ),
                                Text('${item.jumlah}', style: GoogleFonts.nunito()),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => provider.tambahJumlah(item),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => provider.removeFromKeranjang(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: const Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp ${provider.totalHarga()}',
                          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PaymentDialog(
                                totalHarga: provider.totalHarga(),
                                onBayar: () => provider.checkout(),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Checkout',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PaymentDialog extends StatefulWidget {
  final int totalHarga;
  final VoidCallback onBayar;

  const PaymentDialog({
    super.key,
    required this.totalHarga,
    required this.onBayar,
  });

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? _selectedPaymentMethod;
  int _step = 1;

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<ShopProvider>(context, listen: false).keranjang;

    return AlertDialog(
      title: Text(
        _step == 1 ? 'Pilih Metode Pembayaran' : 'Konfirmasi Pesanan',
        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      ),
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
                    ...cartItems.map((item) => ListTile(
                          title: Text(item.nama, style: GoogleFonts.nunito()),
                          subtitle: Text(
                            '${item.jumlah} x Rp ${item.harga}',
                            style: GoogleFonts.nunito(fontSize: 14),
                          ),
                          trailing: Text(
                            'Rp ${item.jumlah * item.harga}',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                    const Divider(thickness: 1),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: Rp ${widget.totalHarga}',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      actions: _step == 1
          ? [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal', style: GoogleFonts.nunito()),
              ),
              ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () => setState(() => _step = 2),
                child: Text('Next', style: GoogleFonts.nunito()),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal', style: GoogleFonts.nunito()),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onBayar();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const ShopPage()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pembayaran Sukses!', style: GoogleFonts.nunito()),
                    ),
                  );
                },
                child: Text('Bayar', style: GoogleFonts.nunito()),
              ),
            ],
    );
  }
}
