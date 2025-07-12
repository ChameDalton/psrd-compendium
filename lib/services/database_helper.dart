import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pathfinder_athenaeum/db/user_database.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final Map<String, Database> _databases = {};

  Future<Database> getDatabase(String dbName) async {
    if (_databases.containsKey(dbName)) {
      return _databases[dbName]!;
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);

    // Copy database from assets if it doesn't exist
    if (!await File(path).exists()) {
      await Directory(dirname(path)).create(recursive: true);
      final bytes = await rootBundle.load('assets/databases/$dbName');
      await File(path).writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }

    final database = await openDatabase(path);
    _databases[dbName] = database;
    return database;
  }

  Future<List<Map<String, dynamic>>> getMenuItems({int? parentMenuId}) async {
    final db = await getDatabase('index.db');
    return db.query(
      'Menu',
      where: parentMenuId != null ? 'Parent_menu_id = ?' : 'Parent_menu_id IS NULL',
      whereArgs: parentMenuId != null ? [parentMenuId] : null,
      orderBy: 'priority, Name',
    );
  }

  Future<List<Map<String, dynamic>>> getSections(String dbName, String type) async {
    final db = await getDatabase(dbName);
    return db.query(
      'central_index',
      where: 'Type = ?',
      whereArgs: [type],
      orderBy: 'Name',
    );
  }

  Future<Map<String, dynamic>?> getSectionWithSubsections(String dbName, int sectionId) async {
    final db = await getDatabase(dbName);
    final sections = await db.query(
      'sections',
      where: 'section_id = ?',
      whereArgs: [sectionId],
    );
    if (sections.isEmpty) return null;

    final result = sections.first;
    final subsections = await db.query(
      'sections',
      where: 'parent_id = ?',
      whereArgs: [sectionId],
      orderBy: 'section_id',
    );
    return {...result, 'subsections': subsections};
  }

  Future<Map<String, dynamic>?> getSpellDetails(String dbName, int spellId) async {
    final db = await getDatabase(dbName);
    final results = await db.query(
      'spells',
      where: '_id = ?',
      whereArgs: [spellId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> closeDatabase() async {
    for (final db in _databases.values) {
      await db.close();
    }
    _databases.clear();
  }
}