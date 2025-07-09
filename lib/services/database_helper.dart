import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase(String dbName) async {
    if (_database == null || _database!.path != join(await getDatabasesPath(), dbName)) {
      await _initDatabase(dbName);
    }
    return _database!;
  }

  static Future<void> _initDatabase(String dbName) async {
    final dbPath = join(await getDatabasesPath(), dbName);
    final exists = await databaseExists(dbPath);

    if (!exists) {
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
        final data = await rootBundle.load('assets/databases/$dbName');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print('Error copying database: $e');
      }
    }

    _database = await openDatabase(dbPath);
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}