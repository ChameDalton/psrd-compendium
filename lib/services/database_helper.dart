import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  Database? _database;
  final String databaseName;

  DatabaseHelper({Database? testDatabase, this.databaseName = 'book-cr.db'})
      : _database = testDatabase;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final directory = await getDatabasesPath();
    final path = join(directory, databaseName);

    // Copy database from assets to app storage if it doesn't exist
    try {
      await Directory(dirname(path)).create(recursive: true);
      final data = await rootBundle.load('assets/$databaseName');
      final bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      // Database already exists or error copying
    }

    _database = await openDatabase(path);
    return _database!;
  }

  Future<List<Map<String, dynamic>>> querySections(String type) async {
    final db = await database;
    // Mimic Java app's query logic: select sections by type
    return db.query(
      'sections',
      where: 'type = ?',
      whereArgs: [type],
      columns: ['id', 'name', 'type', 'parent_id', 'body'],
    );
  }

  Future<List<Map<String, dynamic>>> queryDetails(String parentId) async {
    final db = await database;
    // Query detailed content for a parent_id (e.g., feat benefits)
    return db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
      columns: ['id', 'name', 'body'],
    );
  }
}