import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> initDb() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'user.db');

    _db = await openDatabase(
      path,
      version: 2, // ⬅️ ubah versi jadi 2 biar tabel bahan dibuat juga
      onCreate: (db, version) async {
        // 🔹 Buat tabel users (kode lama tetap)
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        // 🔹 Buat tabel bahan (tabel baru)
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
      },

      // Jika update versi database (misal dari 1 ke 2)
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS bahan (
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
        }
      },
    );

    return _db!;
  }

  // ===========================
  // ====== BAGIAN USER ========
  // ===========================

  static Future<int> insertUser(String name, String email, String password) async {
    final db = await initDb();
    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getUser(String emailOrName, String password) async {
    final db = await initDb();
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
    final db = await initDb();
    final count = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ? OR name = ?',
      whereArgs: [emailOrName, emailOrName],
    );
    return count;
  }

  // ===========================
  // ====== BAGIAN BAHAN =======
  // ===========================

  /// Insert satu bahan
  static Future<int> insertBahan(Map<String, dynamic> data) async {
    final db = await initDb();
    return await db.insert(
      'bahan',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Ambil semua bahan dari tabel
  static Future<List<Map<String, dynamic>>> getAllBahan() async {
    final db = await initDb();
    return await db.query('bahan');
  }

  /// Hapus semua bahan (opsional)
  static Future<void> clearBahan() async {
    final db = await initDb();
    await db.delete('bahan');
  }
}
