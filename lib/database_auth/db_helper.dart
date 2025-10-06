import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> _initDb() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'user.db');

    _db = await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

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
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE purchase_history ADD COLUMN metode TEXT');
        }
      },
    );

    return _db!;
  }

  static Future<Database> get database async => await _initDb();

  // USER
  static Future<int> insertUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getUser(String emailOrName, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: '(email = ? OR name = ?) AND password = ?',
      whereArgs: [emailOrName, emailOrName, password],
      limit: 1,
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  static Future<int> updatePassword(String emailOrName, String newPassword) async {
    final db = await database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ? OR name = ?',
      whereArgs: [emailOrName, emailOrName],
    );
  }

  // BAHAN
  static Future<int> insertBahan(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('bahan', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllBahan() async {
    final db = await database;
    return await db.query('bahan');
  }

  static Future<void> clearBahan() async {
    final db = await database;
    await db.delete('bahan');
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

  // HISTORY
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
