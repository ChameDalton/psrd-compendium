import 'package:sqflite/sqflite.dart';
import 'user_database.dart';
import '../services/database_helper.dart';

class DbWrangler {
  final Map<String, Database> _bookDatabases = {};
  Database? _indexDatabase;
  UserDatabase? _userDatabase;

  Future<void> initializeDatabases() async {
    final assets = [
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

    for (var asset in assets) {
      _bookDatabases[asset] = await DatabaseHelper.getDatabase(asset);
    }

    _indexDatabase = _bookDatabases['index.db'];

    _userDatabase = UserDatabase();
    await _userDatabase!.database;
  }

  Database getBookDatabase(String name) => _bookDatabases['$name.db']!;
  Database getIndexDatabase() => _indexDatabase!;
  UserDatabase getUserDatabase() => _userDatabase!;

  Future<void> close() async {
    for (var db in _bookDatabases.values) {
      await db.close();
    }
    await _userDatabase?.close();
  }
}