import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static final _lock = Lock();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _lock.synchronized(() async {
      if (_database == null) {
        _database = await _initDB('book-cr.db');
      }
      return _database!;
    });
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await DefaultAssetBundle.of(rootBundle).load('assets/databases/$fileName');
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
      } catch (e) {
        print('Error copying database: $e');
      }
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getSections(String type) async {
    final db = await database;
    return await db.query(
      'sections',
      where: 'type = ? AND parent_id IS NULL',
      whereArgs: [type],
    );
  }

  Future<List<Map<String, dynamic>>> getSectionDetails(String parentId) async {
    final db = await database;
    return await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );
  }

  Future<Map<String, dynamic>> getSectionWithSubsections(String sectionId) async {
    final db = await database;
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
    final db = await database;
    _database = null;
    await db.close();
  }
}