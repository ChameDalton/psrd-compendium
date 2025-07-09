import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static const String _dbName = 'psrd_user.db';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            section_id INTEGER,
            name TEXT,
            url TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE history (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            section_id INTEGER,
            name TEXT,
            url TEXT,
            viewed_at INTEGER
          )
        ''');
      },
    );
  }

  Future<void> addBookmark(int sectionId, String name, String url) async {
    final db = await database;
    await db.insert('bookmarks', {
      'section_id': sectionId,
      'name': name,
      'url': url,
    });
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await database;
    return await db.query('bookmarks', orderBy: 'name');
  }

  Future<void> deleteBookmark(int id) async {
    final db = await database;
    await db.delete('bookmarks', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> addHistory(int sectionId, String name, String url, int viewedAt) async {
    final db = await database;
    await db.insert('history', {
      'section_id': sectionId,
      'name': name,
      'url': url,
      'viewed_at': viewedAt,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'viewed_at DESC');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}