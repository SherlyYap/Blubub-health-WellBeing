import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TestHistoryDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'test_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE test_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            test_type TEXT,
            score INTEGER,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertResult(String testType, int score, String date) async {
    final db = await database;
    await db.insert('test_history', {
      'test_type': testType,
      'score': score,
      'date': date,
    });
  }

  static Future<List<Map<String, dynamic>>> getResults(String testType) async {
    final db = await database;
    return await db.query(
      'test_history',
      where: 'test_type = ?',
      whereArgs: [testType],
      orderBy: 'id DESC',
    );
  }

  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('test_history');
  }
}
