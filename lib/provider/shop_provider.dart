import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/database/db_bahan_helper.dart';
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
  int totalHarga() =>
      _keranjang.fold(0, (total, item) => total + item.harga * item.jumlah);
  Future<void> loadBahanFromDb() async {
    final dbData = await BahanDBHelper.getAllBahan();

    if (dbData.isEmpty) {
      for (var bahan in semuaBahanList) {
        await BahanDBHelper.insertBahan(bahan.toMap());
      }
      semuaBahan = semuaBahanList;
    } else {
      semuaBahan = dbData.map((e) => Bahan.fromMap(e)).toList();
      for (var bahan in semuaBahanList) {
        final exists = semuaBahan.any((b) => b.nama == bahan.nama);
        if (!exists) {
          await BahanDBHelper.insertBahan(bahan.toMap());
          semuaBahan.add(bahan);
        }
      }
    }
    final seen = <String>{};
    semuaBahan = semuaBahan.where((b) => seen.add(b.nama)).toList();

    notifyListeners();
  }
  List<Bahan> get filteredItems {
    return semuaBahan.where((bahan) {
      final cocokKategori =
          selectedCategory == 'Semua' || bahan.kategori == selectedCategory;
      final cocokTersedia = !isSwitched || bahan.tersedia;
      final cocokSearch =
          bahan.nama.toLowerCase().contains(_searchQuery.toLowerCase());
      return cocokKategori && cocokTersedia && cocokSearch;
    }).toList();
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
      ));
    }
    notifyListeners();
  }
  void removeFromKeranjang(Bahan bahan) {
    _keranjang.remove(bahan);
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
  void kurangiJumlah(Bahan bahan) => kurangJumlah(bahan);
  void clearKeranjang() {
    _keranjang.clear();
    notifyListeners();
  }
  Future<void> checkout(String metodePembayaran) async {
    if (_keranjang.isEmpty) return;

    for (var item in _keranjang) {
      final index = semuaBahan.indexWhere((b) => b.nama == item.nama);
      if (index != -1) {
        semuaBahan[index].jumlahPembelian += item.jumlah;
        await BahanDBHelper.updateBahan(semuaBahan[index].toMap());
      }
    }

    final itemsJson = jsonEncode(
      _keranjang.map((item) {
        return {
          'nama': item.nama,
          'jumlah': item.jumlah,
          'harga': item.harga,
          'total': item.harga * item.jumlah,
        };
      }).toList(),
    );

    await BahanDBHelper.insertPurchaseHistory(
      itemsJson,
      totalHarga(),
      metodePembayaran,
    );

    _keranjang.clear();
    notifyListeners();
  }
  List<Map<String, dynamic>> _historyList = [];
  List<Map<String, dynamic>> get historyList => _historyList;

  Future<void> loadHistory() async {
    final data = await BahanDBHelper.getPurchaseHistory();
    _historyList = data;
    notifyListeners();
  }
}
