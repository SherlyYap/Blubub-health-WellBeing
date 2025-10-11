import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBChatHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chat_history (
            id TEXT PRIMARY KEY,
            doctorName TEXT,
            text TEXT,
            author TEXT,
            createdAt INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertMessage(String doctorName, String id, String text,
      String author, int createdAt) async {
    final db = await database;
    await db.insert(
      'chat_history',
      {
        'id': id,
        'doctorName': doctorName,
        'text': text,
        'author': author,
        'createdAt': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getMessages(
      String doctorName) async {
    final db = await database;
    return await db.query(
      'chat_history',
      where: 'doctorName = ?',
      whereArgs: [doctorName],
      orderBy: 'createdAt DESC',
    );
  }

  static Future<void> clearChat(String doctorName) async {
    final db = await database;
    await db.delete(
      'chat_history',
      where: 'doctorName = ?',
      whereArgs: [doctorName],
    );
  }
}
