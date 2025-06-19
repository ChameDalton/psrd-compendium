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
    if (_databases.containsKey(dbName)) {
      print('Returning cached database: $dbName');
      return _databases[dbName]!;
    }
    _databases[dbName] = await _initDatabase(dbName);
    return _databases[dbName]!;
  }

  Future<Database> _initDatabase(String dbName) async {
    if (!dbNames.contains(dbName)) {
      throw Exception('Invalid database: $dbName');
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$dbName';
    print('Database path: $path');
    final file = File(path);

    if (!await file.exists()) {
      print('Copying $dbName from assets to $path');
      final data = await rootBundle.load('assets/$dbName');
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes);
      print('$dbName copied successfully');
    } else {
      print('$dbName already exists at $path');
    }

    final db = await openDatabase(path);
    print('Database opened: $dbName');
    return db;
  }

  Future<List<Map<String, dynamic>>> getItemsByType(String type, {String dbName = defaultDbName}) async {
    final db = await getDatabase(dbName);
    print('Querying sections for type: $type in $dbName');
    try {
      final results = await db.query(
        'sections', // Changed from 'section_id' to 'sections'
        columns: ['section_id', 'name', 'description', 'body', 'source', 'type'],
        where: 'type = ?',
        whereArgs: [type],
      );
      print('Query results for $type: $results');
      return results;
    } catch (e) {
      print('Query error: $e');
      rethrow;
    }
  }
}