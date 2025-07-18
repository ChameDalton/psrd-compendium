import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DbWrangler {
  final List<String> _assetDbs = [
    'index.db',
    'advanced_players_guide.db',
    'ultimate_magic.db',
    'ultimate_combat.db',
    'advanced_race_guide.db',
    'advanced_class_guide.db',
    'pathfinder_rpg_core.db',
    'ultimate_equipment.db',
    'ultimate_intrigue.db',
    'occult_adventures.db',
    'mythic_adventures.db',
    'bestiary_1.db',
    'bestiary_2.db',
    'bestiary_3.db',
    'bestiary_4.db',
    'npc_codex.db',
    'monster_codex.db',
    'villain_codex.db',
    'book_of_the_damned.db',
    'horror_adventures.db',
    'inner_sea_world_guide.db',
  ];

  Future<Database> getDatabase(BuildContext context, String dbName) async {
    final dbPath = await _getDbPath(context, dbName);
    return openDatabase(dbPath);
  }

  Future<String> _getDbPath(BuildContext context, String dbName) async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, dbName);
    if (!await File(dbPath).exists()) {
      await _copyDbFromAssets(context, dbName, dbPath);
    }
    return dbPath;
  }

  Future<void> _copyDbFromAssets(BuildContext context, String dbName, String dbPath) async {
    final data = await DefaultAssetBundle.of(context).load('assets/databases/$dbName');
    final bytes = data.buffer.asUint8List();
    await File(dbPath).writeAsBytes(bytes);
  }

  Future<void> initializeDatabases(BuildContext context) async {
    for (final dbName in _assetDbs) {
      await _getDbPath(context, dbName);
    }
    final userDbPath = join(await getDatabasesPath(), 'user.db');
    await openDatabase(
      userDbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            url TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getSections(BuildContext context, String section) async {
    final db = await getDatabase(context, 'index.db');
    final results = await db.query(
      'central_index',
      columns: ['name', 'url'],
      where: 'type = ?',
      whereArgs: [section],
    );
    return results;
  }

  Future<void> addBookmark(String name, String url) async {
    final userDbPath = join(await getDatabasesPath(), 'user.db');
    final db = await openDatabase(userDbPath);
    await db.insert(
      'bookmarks',
      {'name': name, 'url': url},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final userDbPath = join(await getDatabasesPath(), 'user.db');
    final db = await openDatabase(userDbPath);
    return db.query('bookmarks');
  }
}