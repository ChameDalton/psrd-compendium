import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('book-cr.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    // Copy database from assets if it doesn't exist
    bool exists = await databaseExists(path);
    if (!exists) {
      String assetPath = 'assets/databases/$fileName';
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, readOnly: true);
  }

  // Query sections by type (e.g., feat, spell, class)
  Future<List<Map<String, dynamic>>> getSections(String type) async {
    final db = await database;
    return await db.query(
      'sections',
      columns: ['id', 'name', 'type', 'source', 'parent_id', 'body'],
      where: 'type = ?',
      whereArgs: [type],
    );
  }

  // Query detailed content using parent_id
  Future<List<Map<String, dynamic>>> getSectionDetails(String parentId) async {
    final db = await database;
    return await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );
  }

  // Generic search to support existing or future search functionality
  Future<List<Map<String, dynamic>>> searchSections(
      String query, String type) async {
    final db = await database;
    return await db.query(
      'sections',
      where: 'type = ? AND name LIKE ?',
      whereArgs: [type, '%$query%'],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}