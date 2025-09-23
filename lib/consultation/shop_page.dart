import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart'; 

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<Map<String, String>> mentalHealthMedicines = [
    {
      'name': 'Sertraline',
      'price': 'Rp 45.000',
      'description': 'Antidepresan untuk gangguan kecemasan & depresi.',
    },
    {
      'name': 'Fluoxetine',
      'price': 'Rp 40.000',
      'description': 'Meningkatkan suasana hati, digunakan untuk depresi berat.',
    },
    {
      'name': 'Diazepam',
      'price': 'Rp 30.000',
      'description': 'Mengurangi kecemasan, digunakan juga sebagai penenang.',
    },
    {
      'name': 'Lorazepam',
      'price': 'Rp 32.000',
      'description': 'Obat penenang untuk serangan panik & insomnia.',
    },
    {
      'name': 'Haloperidol',
      'price': 'Rp 28.000',
      'description': 'Antipsikotik untuk skizofrenia & gangguan bipolar.',
    },
    {
      'name': 'Olanzapine',
      'price': 'Rp 50.000',
      'description': 'Menstabilkan mood untuk pasien bipolar & skizofrenia.',
    },
    {
      'name': 'Risperidone',
      'price': 'Rp 35.000',
      'description': 'Antipsikotik untuk autisme & bipolar.',
    },
    {
      'name': 'Quetiapine',
      'price': 'Rp 55.000',
      'description': 'Mengurangi delusi, stabilkan mood pasien bipolar.',
    },
    {
      'name': 'Clonazepam',
      'price': 'Rp 33.000',
      'description': 'Obat penenang untuk gangguan panik & kejang.',
    },
    {
      'name': 'Escitalopram',
      'price': 'Rp 48.000',
      'description': 'SSRI untuk gangguan depresi & kecemasan umum.',
    },
  ];

  final List<Map<String, String>> cartItems = [];

  void addToCart(Map<String, String> item) {
    setState(() {
      cartItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item['name']} ditambahkan ke keranjang!',
          style: GoogleFonts.nunito(),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void resetCart() {
    setState(() {
      cartItems.clear();
    });
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartItems: List.from(cartItems),
          onOrderComplete: resetCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Toko Obat Mental Health",
          style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff0D273D),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: navigateToCart,
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color:  Color.fromARGB(255, 87, 156, 212),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: mentalHealthMedicines.length,
        itemBuilder: (context, index) {
          final med = mentalHealthMedicines[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med['name']!,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    med['description']!,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        med['price']!,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: const Color(0xff0D273D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => addToCart(med),
                        child: Text(
                          'Beli',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }
}
