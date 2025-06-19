import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class DatabaseHelper {
  static Map<String, Database> _databases = {};
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
    if (_databases.containsKey(dbName)) return _databases[dbName]!;
    _databases[dbName] = await _initDatabase(dbName);
    return _databases[dbName]!;
  }

  Future<Database> _initDatabase(String dbName) async {
    if (!dbNames.contains(dbName)) {
      throw Exception('Invalid database: $dbName');
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$dbName';
    final file = File(path);

    if (!await file.exists()) {
      final data = await rootBundle.load('assets/$dbName');
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes);
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getItemsByType(String type, {String dbName = defaultDbName}) async {
    final db = await getDatabase(dbName);
    if (type == 'spell') {
      return await db.rawQuery('''
        SELECT s.name, s.description, s.body, s.source, sd.school, sd.level_text
        FROM section_id s
        LEFT JOIN spell_details sd ON s.section_id = sd.section_id
        WHERE s.type = ?
      ''', [type]);
    }
    return await db.query(
      'section_id',
      columns: ['name', 'description', 'body', 'source'],
      where: 'type = ?',
      whereArgs: [type],
    );
  }
}