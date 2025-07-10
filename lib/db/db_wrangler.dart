import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'user_database.dart';
import '../services/database_helper.dart';

class DbWrangler {
  final Map<String, Database> _databases = {};
  UserDatabase? _userDatabase;

  Database getIndexDatabase() {
    return _databases['index.db']!;
  }

  Database getBookDatabase(String dbName) {
    return _databases[dbName]!;
  }

  UserDatabase getUserDatabase() {
    _userDatabase ??= UserDatabase(_databases['user.db']!);
    return _userDatabase!;
  }

  Future<void> initializeDatabases() async {
    final databases = [
      'index.db',
      'book-acg.db',
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
      'book-oa.db',
      'book-ogl.db',
      'book-pfu.db',
      'book-tech.db',
      'book-uc.db',
      'book-ucampaign.db',
      'book-ue.db',
      'book-um.db',
    ];

    for (final dbName in databases) {
      try {
        debugPrint('Initializing database: $dbName');
        _databases[dbName] = await DatabaseHelper.getDatabase(dbName);
        debugPrint('Successfully initialized $dbName');
      } catch (e) {
        debugPrint('Error initializing $dbName: $e');
        rethrow;
      }
    }
  }

  Future<void> closeDatabases() async {
    for (final db in _databases.values) {
      await db.close();
    }
    _databases.clear();
    _userDatabase = null;
    debugPrint('All databases closed');
  }
}