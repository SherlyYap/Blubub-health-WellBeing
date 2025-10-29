import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'journaling.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE journal (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            dateTime TEXT,
            color INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertEntry(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('journal', data);
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return await db.query('journal');
  }

  Future<int> updateEntry(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('journal', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete('journal', where: 'id = ?', whereArgs: [id]);
  }
}
