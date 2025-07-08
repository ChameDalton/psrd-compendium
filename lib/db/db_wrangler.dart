import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'user_database.dart';

class DbWrangler {
  Map<String, Database> _bookDatabases = {};
  Database? _indexDatabase;
  UserDatabase? _userDatabase;

  Future<void> initializeDatabases() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final assets = ['book-pfsrd.db', 'index.db']; // Add other book DBs as needed

    // Copy book and index databases from assets
    for (var asset in assets) {
      final dbPath = join(dbDir.path, asset);
      final exists = await databaseExists(dbPath);
      if (!exists) {
        final data = await rootBundle.load('assets/$asset');
        final buffer = data.buffer;
        await File(dbPath).writeAsBytes(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      }
      _bookDatabases[asset] = await openDatabase(dbPath);
    }

    // Initialize index database
    _indexDatabase = _bookDatabases['index.db'];

    // Initialize user database (created, not copied)
    _userDatabase = UserDatabase();
    await _userDatabase!.database; // Trigger creation
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