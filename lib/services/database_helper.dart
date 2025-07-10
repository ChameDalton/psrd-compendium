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
        debugPrint('Copying database: $dbName');
        await Directory(dirname(dbPath)).create(recursive: true);
        final data = await rootBundle.load('assets/databases/$dbName');
        if (data.lengthInBytes == 0) {
          debugPrint('Error: $dbName is empty');
          throw Exception('Database asset $dbName is empty');
        }
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes, flush: true);
        debugPrint('Successfully copied $dbName to $dbPath');
      } catch (e) {
        debugPrint('Error copying database $dbName: $e');
        rethrow;
      }
    } else {
      debugPrint('Database $dbName already exists at $dbPath');
    }

    try {
      _database = await openDatabase(dbPath);
      debugPrint('Database $dbName opened successfully');
    } catch (e) {
      debugPrint('Error opening database $dbName: $e');
      rethrow;
    }
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<List<Map<String, dynamic>>> getSections(String dbName, String sectionType) async {
    try {
      final db = await getDatabase(dbName);
      final result = await db.query(
        'central_index',
        where: 'Type = ?',
        whereArgs: [sectionType],
        orderBy: 'Name',
      );
      debugPrint('Query central_index for Type $sectionType returned ${result.length} rows');
      return result;
    } catch (e) {
      debugPrint('Error querying central_index for $sectionType in $dbName: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMenuItems({int? parentMenuId}) async {
    try {
      final db = await getDatabase('index.db');
      final result = await db.query(
        'Menu',
        where: parentMenuId == null ? 'Parent_menu_id IS NULL' : 'Parent_menu_id = ?',
        whereArgs: parentMenuId != null ? [parentMenuId] : null,
        orderBy: 'priority, Name',
      );
      debugPrint('Query Menu for Parent_menu_id ${parentMenuId ?? 'NULL'} returned ${result.length} rows');
      return result;
    } catch (e) {
      debugPrint('Error querying Menu for Parent_menu_id ${parentMenuId ?? 'NULL'}: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getSectionWithSubsections(String dbName, String sectionId) async {
    try {
      final db = await getDatabase(dbName);
      final section = await db.query(
        'central_index',
        where: 'Section_id = ?',
        whereArgs: [sectionId],
        limit: 1,
      );
      if (section.isEmpty) {
        debugPrint('No section found for id $sectionId in $dbName');
        return {};
      }

      final subsections = await db.query(
        'central_index',
        where: 'Parent_id = ?',
        whereArgs: [sectionId],
        orderBy: 'Name',
      );

      return {
        'section': section.first,
        'subsections': subsections,
      };
    } catch (e) {
      debugPrint('Error querying section $sectionId in $dbName: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSpellDetails(String dbName, String sectionId) async {
    try {
      final db = await getDatabase(dbName);
      final spell = await db.query(
        'spells',
        where: '_id = ?',
        whereArgs: [sectionId],
        limit: 1,
      );
      return spell.isNotEmpty ? spell.first : {};
    } catch (e) {
      debugPrint('Error querying spell $sectionId in $dbName: $e');
      return {};
    }
  }
}