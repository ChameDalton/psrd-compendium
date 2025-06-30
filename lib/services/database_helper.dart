// lib/services/database_helper.dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final Map<String, Database> _databases = {};
  static const String defaultDbName = 'book-cr.db';
  static const List<String> dbNames = [
    'book-apg.db',
    'book-arg.db',
    'book-b1.db',
    'book-b2.db',
    'book-b3.db',
    'book-b4.db',
    'book-cr.db',
    'book-gmg.db',
    'book-ma.db',
    'book-mc.db',
    'book-npc.db',
    'book-tech.db',
    'book-uc.db',
    'book-ucampaign.db',
    'book-ue.db',
    'book-um.db',
  ];

  Future<Database> getDatabase(String dbName) async {
    if (_databases.containsKey(dbName)) {
      return _databases[dbName]!;
    }
    _databases[dbName] = await _initDatabase(dbName);
    return _databases[dbName]!;
  }

  Future<Database> _initDatabase(String dbName) async {
    // ignore: avoid_print
    print('Initializing database: $dbName');
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDir.path, dbName);
    if (!await File(dbPath).exists()) {
      // ignore: avoid_print
      print('Copying $dbName from assets to $dbPath');
      final data = await rootBundle.load('assets/$dbName');
      final bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes);
      // ignore: avoid_print
      print('$dbName copied successfully');
    }
    // ignore: avoid_print
    print('Opening database: $dbPath');
    final db = await openDatabase(dbPath);
    // ignore: avoid_print
    print('Database $dbName opened');
    return db;
  }

  Future<List<Map<String, dynamic>>> getItemsByType(String type, {String dbName = defaultDbName}) async {
    final db = await getDatabase(dbName);
    // ignore: avoid_print
    print('Querying sections for type: $type in $dbName');
    try {
      String query;
      List<dynamic> whereArgs = [type];
      if (type == 'spell') {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 sd.school, sd.level_text, sd.subschool, sd.descriptor
          FROM sections s
          LEFT JOIN spell_details sd ON s.section_id = sd.section_id
          WHERE s.type = ?
        ''';
      } else if (type == 'skill') {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 sa.attribute, sa.armor_check_penalty, sa.trained_only
          FROM sections s
          LEFT JOIN skill_attributes sa ON s.section_id = sa.section_id
          WHERE s.type = ?
        ''';
      } else if (type == 'feat') {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 fd.prerequisites, fd.type AS feat_type
          FROM sections s
          LEFT JOIN feat_details fd ON s.section_id = fd.section_id
          WHERE s.type = ?
        ''';
      } else if (type == 'monster') {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 ca.challenge_rating, ca.size, ca.alignment
          FROM sections s
          LEFT JOIN creature_attributes ca ON s.section_id = ca.section_id
          WHERE s.type = ?
        ''';
      } else {
        query = '''
          SELECT section_id, name, description, body, source, type
          FROM sections
          WHERE type = ?
        ''';
      }
      final results = await db.rawQuery(query, whereArgs);
      // ignore: avoid_print
      print('Query results for $type: ${results.length} items');
      return results;
    } catch (e) {
      // ignore: avoid_print
      print('Query error for $type in $dbName: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getItemBySectionId(String sectionId, {String dbName = defaultDbName}) async {
    final db = await getDatabase(dbName);
    // ignore: avoid_print
    print('Querying section_id: $sectionId in $dbName');
    try {
      String query;
      if (sectionId.startsWith('spell_')) {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 sd.school, sd.level_text, sd.subschool, sd.descriptor
          FROM sections s
          LEFT JOIN spell_details sd ON s.section_id = sd.section_id
          WHERE s.section_id = ?
        ''';
      } else if (sectionId.startsWith('skill_')) {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 sa.attribute, sa.armor_check_penalty, sa.trained_only
          FROM sections s
          LEFT JOIN skill_attributes sa ON s.section_id = sa.section_id
          WHERE s.section_id = ?
        ''';
      } else if (type == 'feat') {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 fd.prerequisites, fd.type AS feat_type
          FROM sections s
          LEFT JOIN feat_details fd ON s.section_id = fd.section_id
          WHERE s.section_id = ?
        ''';
      } else if (type == 'monster') {
        query = '''
          SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
                 ca.challenge_rating, ca.size, ca.alignment
          FROM sections s
          LEFT JOIN creature_attributes ca ON s.section_id = ca.section_id
          WHERE s.section_id = ?
        ''';
      } else {
        query = '''
          SELECT section_id, name, description, body, source, type
          FROM sections
          WHERE section_id = ?
        ''';
      }
      final results = await db.rawQuery(query, [sectionId]);
      // ignore: avoid_print
      print('Query result for section_id $sectionId: ${results.length} items');
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      // ignore: avoid_print
      print('Query error for section_id $sectionId in $dbName: $e');
      rethrow;
    }
  }

  Future<void> logSchema() async {
    final db = await getDatabase(defaultDbName);
    final tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table";');
    print('Tables: $tables');
    final columns = await db.rawQuery('PRAGMA table_info(sections);');
    print('Columns: $columns');
  }
}