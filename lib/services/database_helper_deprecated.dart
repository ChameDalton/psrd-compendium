import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'book-cr.db');

    // Copy the database from assets if not already present
    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load('assets/book-cr.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, readOnly: true);
  }

  static Future<List<String>> getTableNames(Database db) async {
    final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';");

    return tables.map((table) => table['name'].toString()).toList();
  }

  static Future<List<String>> verifyTables(Database db) async {
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';");
    print("Tables found in database: $tables"); // Debugging output
    return tables.map((table) => table['name'].toString()).toList();
  }


  //static Future<List<Map<String, dynamic>>> queryTable(Database db, String tableName) async {
   // return await db.query(tableName);
  //}

  static Future<List<Map<String, dynamic>>> queryTable(Database db, String tableName) async {
    final results = await db.query(tableName);
    print("Data in $tableName: ${results.length} entries");
    return results;
  }

  //static Future<List<Map<String, dynamic>>> fetchTableData(Database db, String tableName) async {
  //  return await db.query(tableName);
  //}

  static Future<List<Map<String, dynamic>>> fetchTableData(Database db, String tableName) async {
    final results = await db.query(tableName);
    print("Table '$tableName' contains ${results.length} entries.");
    return results;
  }
}