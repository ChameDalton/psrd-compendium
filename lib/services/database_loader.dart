import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLoader {
  static Future<Database> loadDatabaseFrom(String assetFileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = join(dir.path, assetFileName);

    if (!File(targetPath).existsSync()) {
      final byteData = await rootBundle.load('assets/$assetFileName');
      await File(targetPath).writeAsBytes(
        byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        flush: true,
      );
    }

    return openDatabase(targetPath);
  }
}
