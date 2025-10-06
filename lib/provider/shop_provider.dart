import 'package:flutter/material.dart';
import 'package:project/database_auth/db_helper.dart';
import 'package:project/health_food/shop/data_bahan.dart';

class Bahan {
  final String nama;
  final int harga;
  final bool tersedia;
  final String gambar;
  final String satuan;
  final String kategori;
  int jumlahPembelian;
  int jumlah;

  Bahan({
    required this.nama,
    required this.harga,
    required this.tersedia,
    required this.gambar,
    required this.satuan,
    required this.kategori,
    this.jumlahPembelian = 0,
    this.jumlah = 1,
  });

  /// 🔹 Convert ke Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'harga': harga,
      'tersedia': tersedia ? 1 : 0,
      'gambar': gambar,
      'satuan': satuan,
      'kategori': kategori,
      'jumlahPembelian': jumlahPembelian,
    };
  }

  /// 🔹 Convert dari Map (ambil dari SQLite)
  factory Bahan.fromMap(Map<String, dynamic> map) {
    return Bahan(
      nama: map['nama'],
      harga: map['harga'],
      tersedia: map['tersedia'] == 1,
      gambar: map['gambar'],
      satuan: map['satuan'],
      kategori: map['kategori'],
      jumlahPembelian: map['jumlahPembelian'] ?? 0,
    );
  }
}

class ShopProvider extends ChangeNotifier {
  String selectedCategory = 'Semua';
  bool isSwitched = false;
  String _searchQuery = '';

  List<Bahan> semuaBahan = [];
  final List<Bahan> _keranjang = [];

  List<Bahan> get keranjang => _keranjang;
  int get totalKeranjang => _keranjang.length;
  int totalHarga() => _keranjang.fold(0, (total, item) => total + item.harga * item.jumlah);

  /// 🔹 Ambil data bahan dari database
  Future<void> loadBahanFromDb() async {
    final dbData = await DBHelper.getAllBahan();

    if (dbData.isEmpty) {
      // kalau belum ada data, seed dari data_bahan.dart
      for (var bahan in semuaBahanList) {
        await DBHelper.insertBahan(bahan.toMap());
      }
      semuaBahan = semuaBahanList;
      print('✅ Data awal bahan disimpan ke database');
    } else {
      semuaBahan = dbData.map((e) => Bahan.fromMap(e)).toList();
      print('✅ Data bahan diambil dari database');
    }

    notifyListeners();
  }

  List<Bahan> get filteredItems {
    return semuaBahan.where((bahan) {
      final cocokKategori = selectedCategory == 'Semua' || bahan.kategori == selectedCategory;
      final cocokTersedia = !isSwitched || bahan.tersedia;
      final cocokSearch = bahan.nama.toLowerCase().contains(_searchQuery.toLowerCase());
      return cocokKategori && cocokTersedia && cocokSearch;
    }).toList();
  }

  List<Bahan> getTopItems(String kategori, [int count = 5]) {
    final items = semuaBahan.where((item) => item.kategori == kategori).toList();
    items.sort((a, b) => b.jumlahPembelian.compareTo(a.jumlahPembelian));
    return items.take(count).toList();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void toggleSwitch(bool value) {
    isSwitched = value;
    notifyListeners();
  }

  void selectCategory(String? value) {
    if (value != null) {
      selectedCategory = value;
      notifyListeners();
    }
  }

  void tambahKeKeranjang(Bahan bahan) {
    final index = _keranjang.indexWhere((item) => item.nama == bahan.nama);
    if (index != -1) {
      _keranjang[index].jumlah += 1;
    } else {
      _keranjang.add(Bahan(
        nama: bahan.nama,
        harga: bahan.harga,
        tersedia: bahan.tersedia,
        gambar: bahan.gambar,
        satuan: bahan.satuan,
        kategori: bahan.kategori,
        jumlahPembelian: bahan.jumlahPembelian,
        jumlah: 1,
      ));
    }
    notifyListeners();
  }

  void removeFromKeranjang(Bahan bahan) {
    _keranjang.remove(bahan);
    notifyListeners();
  }

  void checkout() {
    for (var item in _keranjang) {
      final index = semuaBahan.indexWhere((b) => b.nama == item.nama);
      if (index != -1) {
        semuaBahan[index].jumlahPembelian += item.jumlah;
      }
    }
    _keranjang.clear();
    notifyListeners();
  }

  void tambahJumlah(Bahan bahan) {
    final index = _keranjang.indexOf(bahan);
    if (index != -1) {
      _keranjang[index].jumlah += 1;
      notifyListeners();
    }
  }

  void kurangJumlah(Bahan bahan) {
    final index = _keranjang.indexOf(bahan);
    if (index != -1 && _keranjang[index].jumlah > 1) {
      _keranjang[index].jumlah -= 1;
    } else {
      removeFromKeranjang(bahan);
    }
    notifyListeners();
  }
}
