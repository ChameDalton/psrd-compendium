import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
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
        debugPrint('Error copying database: $e');
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

  Future<List<Map<String, dynamic>>> getSections(String dbName, String sectionType) async {
    final db = await getDatabase(dbName);
    return await db.query(
      'sections',
      where: 'type = ?',
      whereArgs: [sectionType],
      orderBy: 'name',
    );
  }

  Future<Map<String, dynamic>> getSectionWithSubsections(String dbName, String sectionId) async {
    final db = await getDatabase(dbName);
    final section = await db.query(
      'sections',
      where: '_id = ?',
      whereArgs: [sectionId],
      limit: 1,
    );
    if (section.isEmpty) return {};

    final subsections = await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [sectionId],
      orderBy: 'name',
    );

    return {
      'section': section.first,
      'subsections': subsections,
    };
  }

  Future<Map<String, dynamic>> getSpellDetails(String dbName, String sectionId) async {
    final db = await getDatabase(dbName);
    final spell = await db.query(
      'spells',
      where: '_id = ?',
      whereArgs: [sectionId],
      limit: 1,
    );
    return spell.isNotEmpty ? spell.first : {};
  }
}