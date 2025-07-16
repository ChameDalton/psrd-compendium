import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbWrangler {
  final Map<String, Database> _databases = {};

  Future<Database> getDatabase(String dbName) async {
    if (_databases.containsKey(dbName)) {
      return _databases[dbName]!;
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);

    if (!await File(path).exists()) {
      final data = await DefaultAssetBundle.of(rootBundle).load('assets/databases/$dbName');
      final bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    final database = await openDatabase(path);
    _databases[dbName] = database;
    return database;
  }

  Future<Database> initializeUserDb() async {
    if (_databases.containsKey('user.db')) {
      return _databases['user.db']!;
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'user.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Bookmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            url TEXT
          )
        ''');
      },
    );

    _databases['user.db'] = database;
    return database;
  }

  Future<List<Map<String, dynamic>>> getSections(String type) async {
    final db = await getDatabase('index.db');
    return db.query(
      'central_index',
      columns: ['name', 'url'],
      where: 'type = ?',
      whereArgs: [type],
    );
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await initializeUserDb();
    return db.query('Bookmarks');
  }

  Future<void> addBookmark(String name, String url) async {
    final db = await initializeUserDb();
    await db.insert('Bookmarks', {'name': name, 'url': url});
  }

  Future<void> closeDatabase(String dbName) async {
    if (_databases.containsKey(dbName)) {
      await _databases[dbName]!.close();
      _databases.remove(dbName);
    }
  }
}
