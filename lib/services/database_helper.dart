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

  // Map of type to parent_id based on database structure
  static const Map<String, int> _typeToParentId = {
    'spell': 2,    // Spells under section_id=2 (type='list', name='Spells')
    'feat': 1061,  // Feats under section_id=1061 (type='list', name='Feats')
    'class': 1636, // Classes under section_id=1636 (type='list', name='Classes')
  };

  Future<Database> database(BuildContext context) async {
    if (_database != null) {
      debugPrint('Database already initialized');
      return _database!;
    }
    debugPrint('Initializing database...');
    final db = await _lock.synchronized(() => _initDB(context, 'book-cr.db'));
    _database = db;
    debugPrint('Database initialized at: ${db.path}');
    return db;
  }

  Future<Database> _initDB(BuildContext context, String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    debugPrint('Database path: $path');

    final exists = await databaseExists(path);
    debugPrint('Database exists: $exists');
    if (!exists) {
      try {
        debugPrint('Creating directory: ${dirname(path)}');
        await Directory(dirname(path)).create(recursive: true);
        debugPrint('Loading asset: assets/databases/$fileName');
        // ignore: use_build_context_synchronously
        final data = await DefaultAssetBundle.of(context).load('assets/databases/$fileName');
        debugPrint('Asset loaded, size: ${data.lengthInBytes} bytes');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        debugPrint('Writing database to: $path');
        await File(path).writeAsBytes(bytes);
        debugPrint('Database written successfully');
      } catch (e) {
        debugPrint('Error initializing database: $e');
        rethrow;
      }
    }

    final db = await openDatabase(path);
    debugPrint('Database opened: ${db.path}');
    return db;
  }

  Future<List<Map<String, dynamic>>> getSections(BuildContext context, String type) async {
    // ignore: use_build_context_synchronously
    final db = await database(context);
    final parentId = _typeToParentId[type];
    if (parentId == null) {
      debugPrint('Error: No parent_id defined for type: $type');
      return [];
    }
    debugPrint('Querying sections for type: $type, parent_id: $parentId');
    final result = await db.query(
      'sections',
      where: 'type = ? AND parent_id = ?',
      whereArgs: [type, parentId],
    );
    debugPrint('Sections found for type $type: ${result.length}');
    return result;
  }

  Future<List<Map<String, dynamic>>> getSectionDetails(BuildContext context, String parentId) async {
    // ignore: use_build_context_synchronously
    final db = await database(context);
    debugPrint('Querying section details for parent_id: $parentId');
    final result = await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );
    debugPrint('Section details found for parent_id $parentId: ${result.length}');
    return result;
  }

  Future<Map<String, dynamic>> getSectionWithSubsections(BuildContext context, String sectionId) async {
    // ignore: use_build_context_synchronously
    final db = await database(context);
    debugPrint('Querying section with subsections for section_id: $sectionId');
    // Fetch the top-level section
    final section = await db.query(
      'sections',
      where: 'section_id = ?',
      whereArgs: [sectionId],
    );
    debugPrint('Top-level section found for section_id $sectionId: ${section.length}');

    if (section.isEmpty) {
      debugPrint('No section found for section_id: $sectionId');
      return {'section': null, 'subsections': []};
    }

    // Fetch subsections recursively
    // ignore: use_build_context_synchronously
    final subsections = await _getSubsections(context, sectionId, db);
    debugPrint('Subsections found for section_id $sectionId: ${subsections.length}');

    return {
      'section': section.first,
      'subsections': subsections,
    };
  }

  Future<List<Map<String, dynamic>>> _getSubsections(BuildContext context, String parentId, Database db) async {
    debugPrint('Querying subsections for parent_id: $parentId');
    final subsections = await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );
    debugPrint('Subsections found for parent_id $parentId: ${subsections.length}');

    List<Map<String, dynamic>> result = [];
    for (var subsection in subsections) {
      // ignore: use_build_context_synchronously
      final nestedSubsections = await _getSubsections(context, subsection['section_id'].toString(), db);
      result.add({
        'section': subsection,
        'subsections': nestedSubsections,
      });
    }
    return result;
  }

  Future close(BuildContext context) async {
    // ignore: use_build_context_synchronously
    final db = await database(context);
    debugPrint('Closing database');
    _database = null;
    await db.close();
    debugPrint('Database closed');
  }
}