import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static final _lock = Lock();

  DatabaseHelper._init();

  Future<Database> database(BuildContext context) async {
    if (_database != null) {
      return _database!;
    }
    final db = await _lock.synchronized(() => _initDB(context, 'book-cr.db'));
    _database = db;
    return db;
  }

  Future<Database> _initDB(BuildContext context, String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        // ignore: use_build_context_synchronously
        final data = await DefaultAssetBundle.of(context).load('assets/databases/$fileName');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
      } catch (e) {
        // Handle error appropriately in production (e.g., logging)
        rethrow;
      }
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getSections(String type) async {
    final db = await database(BuildContext as BuildContext);
    return await db.query(
      'sections',
      where: 'type = ? AND parent_id IS NULL',
      whereArgs: [type],
    );
  }

  Future<List<Map<String, dynamic>>> getSectionDetails(String parentId) async {
    final db = await database(BuildContext as BuildContext);
    return await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );
  }

  Future<Map<String, dynamic>> getSectionWithSubsections(String sectionId) async {
    final db = await database(BuildContext as BuildContext);
    // Fetch the top-level section
    final section = await db.query(
      'sections',
      where: 'section_id = ?',
      whereArgs: [sectionId],
    );

    if (section.isEmpty) {
      return {'section': null, 'subsections': []};
    }

    // Fetch subsections recursively
    final subsections = await _getSubsections(sectionId, db);

    return {
      'section': section.first,
      'subsections': subsections,
    };
  }

  Future<List<Map<String, dynamic>>> _getSubsections(String parentId, Database db) async {
    final subsections = await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );

    List<Map<String, dynamic>> result = [];
    for (var subsection in subsections) {
      final nestedSubsections = await _getSubsections(subsection['section_id'].toString(), db);
      result.add({
        'section': subsection,
        'subsections': nestedSubsections,
      });
    }
    return result;
  }

  Future close() async {
    final db = await database(BuildContext as BuildContext);
    _database = null;
    await db.close();
  }
}