import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/health_food/shop/cart_healthyfood.dart';
import 'package:project/provider/shop_provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Healthy Food Shop', style: GoogleFonts.nunito()),
          backgroundColor: const Color.fromARGB(255, 202, 231, 255),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: const Color(0xff0D273D),
            ),
            tabs: const [Tab(text: 'Vegetable'), Tab(text: 'Meat')],
          ),
        ),
        body: const TabBarView(
          children: [
            BahanMakananTab(category: 'Vegetable'),
            BahanMakananTab(category: 'Meat'),
          ],
        ),
        floatingActionButton: Consumer<ShopProvider>(
          builder:
              (context, provider, child) => Stack(
                children: [
                  FloatingActionButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        ),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  if (provider.keranjang.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff0D273D),
                        radius: 10,
                        child: Text(
                          provider.keranjang.length.toString(),
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ),
    );
  }
}

class BahanMakananTab extends StatelessWidget {
  final String category;
  const BahanMakananTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context);
    final items =
        provider.filteredItems.where((i) => i.kategori == category).toList();
    final popularItems = List.from(items)
      ..sort((a, b) => b.jumlahPembelian.compareTo(a.jumlahPembelian));

    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('img-project/profile.png'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang, Groupie!',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nikmati belanja $category sehat',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xff0D273D),
                    ),
                  ),
                  Text(
                    'Pesan sekarang!',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xff0D273D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 6, 
              child: Image.asset(
                'img-project/banner_healthyfood.jpeg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: provider.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              hintStyle: GoogleFonts.nunito(),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Switch(
                value: provider.isSwitched,
                onChanged: provider.toggleSwitch,
              ),
              Text('Stok Tersedia', style: GoogleFonts.nunito()),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Populer',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: popularItems.take(5).length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder:
                  (context, index) => ProductCard(
                    item: popularItems[index],
                    isHorizontal: true,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Semua Produk',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width < 360 ? 2 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: width < 360 ? 0.7 : 0.9,
            ),
            itemBuilder: (context, index) => ProductCard(item: items[index]),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Bahan item;
  final bool isHorizontal;
  const ProductCard({super.key, required this.item, this.isHorizontal = false});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return SizedBox(
      width: isHorizontal ? 140 : null,
      height: isHorizontal ? 200 : null, 
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                item.gambar,
                height: isHorizontal ? 90 : (isSmallScreen ? 80 : 100),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: isSmallScreen ? 11.5 : 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rp ${item.harga}',
                      style: GoogleFonts.nunito(
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0D273D),
                      ),
                    ),
                    Text(
                      item.satuan,
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    item.tersedia
                        ? SizedBox(
                            width: double.infinity,
                            height: 26,
                            child: ElevatedButton(
                              onPressed: () {
                                provider.tambahKeKeranjang(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${item.nama} ditambahkan ke keranjang.',
                                      style: GoogleFonts.nunito(),
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff0D273D),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_cart_outlined, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Add',
                                    style: GoogleFonts.nunito(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              'Tidak Tersedia',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
