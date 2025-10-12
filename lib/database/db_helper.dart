import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> _initDb() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), 'user.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<Database> get database async => await _initDb();

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
}
