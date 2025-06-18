// lib/services/feat_service.dart
import 'package:sqflite/sqflite.dart';
import '../models/feat_reference.dart';
import 'database_loader.dart';

class FeatService {
  static Future<List<FeatReference>> loadCoreFeats() async {
    final db = await DatabaseLoader.loadDatabaseFrom('book-cr.db');

    final result = await db.rawQuery("""
      SELECT s.section_id, s.name, s.description, s.url, s.type, s.subtype, 
            ft.feat_type, ftd.feat_type_description
      FROM sections s
      LEFT JOIN feat_types ft ON s.section_id = ft.section_id
      LEFT JOIN feat_type_descriptions ftd ON s.section_id = ftd.section_id
      WHERE s.type = 'feat'
    """);

    return result.map((row) => FeatReference.fromMap(row)).toList();
  }
}
