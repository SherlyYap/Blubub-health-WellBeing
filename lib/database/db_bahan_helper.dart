import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BahanDBHelper {
  static Database? _db;

  static Future<Database> _initDb() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), 'bahan.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bahan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            harga INTEGER,
            tersedia INTEGER,
            gambar TEXT,
            satuan TEXT,
            kategori TEXT,
            jumlahPembelian INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE purchase_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            total INTEGER,
            items TEXT,
            metode TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS purchase_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              tanggal TEXT,
              total INTEGER,
              items TEXT,
              metode TEXT
            )
          ''');
        }
      },
    );

    return _db!;
  }

  static Future<Database> get database async => await _initDb();

  static Future<int> insertBahan(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('bahan', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllBahan() async {
    final db = await database;
    return await db.query('bahan');
  }

  static Future<void> updateBahan(Map<String, dynamic> data) async {
    final db = await database;
    await db.update(
      'bahan',
      data,
      where: 'nama = ?',
      whereArgs: [data['nama']],
    );
  }

  static Future<void> clearBahan() async {
    final db = await database;
    await db.delete('bahan');
  }

  static Future<void> insertPurchaseHistory(String items, int total, String metode) async {
    final db = await database;
    await db.insert('purchase_history', {
      'tanggal': DateTime.now().toIso8601String(),
      'total': total,
      'items': items,
      'metode': metode,
    });
  }

  static Future<List<Map<String, dynamic>>> getPurchaseHistory() async {
    final db = await database;
    return await db.query('purchase_history', orderBy: 'id DESC');
  }

  static Future<void> clearPurchaseHistory() async {
    final db = await database;
    await db.delete('purchase_history');
  }
}
