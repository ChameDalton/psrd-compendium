import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DbWrangler {
  final Map<String, Database> _databases = {};
  late Database _userDb;

  Database get userDb => _userDb;

  Future<void> initializeUserDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');
    _userDb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Bookmarks (
            id INTEGER PRIMARY KEY,
            name TEXT,
            url TEXT,
            scroll INTEGER,
            section_id INTEGER
          )
        ''');
      },
    );
  }

  Future<Database> getDatabase(String dbName) async {
    if (_databases.containsKey(dbName)) {
      return _databases[dbName]!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    if (!await databaseExists(path)) {
      final data = await rootBundle.load('assets/databases/$dbName');
      final bytes = data.buffer.asUint8List();
      await writeFile(path, bytes);
    }

    final database = await openDatabase(path);
    _databases[dbName] = database;
    return database;
  }

  Future<void> closeDatabase() async {
    for (final db in _databases.values) {
      await db.close();
    }
    await _userDb.close();
    _databases.clear();
  }

  Future<void> writeFile(String path, List<int> bytes) async {
    final file = File(path);
    await file.write(bytes);
  }
}