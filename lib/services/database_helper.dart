import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  Database? _database;

  final Map<String, int> _typeToParentId = {
    'spell': 2,
    'feat': 1061,
    'class': 1636,
    'race': 701,
  };

  Future<void> initDatabase() async {
    if (_database != null) {
      debugPrint('Database already initialized');
      return;
    }

    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'book-cr.db');

      debugPrint('Initializing database...');
      debugPrint('Database path: $path');

      final exists = await databaseExists(path);
      debugPrint('Database exists: $exists');

      if (!exists) {
        ByteData data = await DefaultAssetBundle.of(WidgetsFlutterBinding.ensureInitialized().rootBundle).load('assets/databases/book-cr.db');
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await writeToFile(path, bytes);
      }

      _database = await openDatabase(path, readOnly: true);
      debugPrint('Database opened: $path');
      debugPrint('Database initialized at: $path');
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> writeToFile(String path, List<int> bytes) async {
    // Implementation remains unchanged
  }

  Future<List<Map<String, dynamic>>> getSections(BuildContext context, String type) async {
    if (_database == null) {
      await initDatabase();
    }

    final parentId = _typeToParentId[type];
    if (parentId == null) {
      debugPrint('No parent_id defined for type: $type');
      return [];
    }

    try {
      debugPrint('Querying sections for type: $type, parent_id: $parentId');
      final List<Map<String, dynamic>> result = await _database!.query(
        'sections',
        columns: ['section_id', 'name', 'type', 'parent_id'],
        where: 'type = ? AND parent_id = ?',
        whereArgs: [type, parentId],
        orderBy: 'name ASC',
      );
      debugPrint('Sections found for type $type: ${result.length}');
      return result;
    } catch (e) {
      debugPrint('Error querying sections for type $type: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getSectionWithSubsections(BuildContext context, String sectionId) async {
    if (_database == null) {
      await initDatabase();
    }

    try {
      final List<Map<String, dynamic>> sectionResult = await _database!.query(
        'sections',
        where: 'section_id = ?',
        whereArgs: [sectionId],
      );

      final List<Map<String, dynamic>> subsectionResult = await _database!.query(
        'sections',
        where: 'parent_id = ?',
        whereArgs: [sectionId],
        orderBy: 'section_id ASC',
      );

      debugPrint('Subsections found for parent_id $sectionId: ${subsectionResult.length}');

      return {
        'section': sectionResult.isNotEmpty ? sectionResult.first : {},
        'subsections': subsectionResult,
      };
    } catch (e) {
      debugPrint('Error querying section with subsections for section_id $sectionId: $e');
      return {'section': {}, 'subsections': []};
    }
  }

  Future<Map<String, dynamic>> getSpellDetails(BuildContext context, String sectionId) async {
    if (_database == null) {
      await initDatabase();
    }

    try {
      debugPrint('Querying spell details for section_id: $sectionId');

      final List<Map<String, dynamic>> sectionResult = await _database!.query(
        'sections',
        where: 'section_id = ?',
        whereArgs: [sectionId],
      );

      final List<Map<String, dynamic>> spellDetailsResult = await _database!.query(
        'spell_details',
        where: 'section_id = ?',
        whereArgs: [sectionId],
      );

      final List<Map<String, dynamic>> spellEffectsResult = await _database!.query(
        'spell_effects',
        where: 'section_id = ?',
        whereArgs: [sectionId],
      );

      final List<Map<String, dynamic>> subsectionResult = await _database!.query(
        'sections',
        where: 'parent_id = ?',
        whereArgs: [sectionId],
        orderBy: 'section_id ASC',
      );

      debugPrint('Subsections found for parent_id $sectionId: ${subsectionResult.length}');
      debugPrint('Spell details found for section_id $sectionId: details=${spellDetailsResult.length}, effects=${spellEffectsResult.length}, subsections=${subsectionResult.length}');

      return {
        'section': sectionResult.isNotEmpty ? sectionResult.first : {},
        'spell_details': spellDetailsResult.isNotEmpty ? spellDetailsResult.first : {},
        'spell_effects': spellEffectsResult,
        'subsections': subsectionResult,
      };
    } catch (e) {
      debugPrint('Error querying spell details for section_id $sectionId: $e');
      return {'section': {}, 'spell_details': {}, 'spell_effects': [], 'subsections': []};
    }
  }
}