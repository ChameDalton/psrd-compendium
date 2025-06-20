import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class DetailsScreen extends StatelessWidget {
  final String type;
  final String sectionId;

  const DetailsScreen({super.key, required this.type, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    // Map 'creatures' to 'monster'
    final queryType = type.toLowerCase() == 'creature' ? 'monster' : type.toLowerCase();
    // ignore: avoid_print
    print('DetailsScreen: type=$queryType, sectionId=$sectionId');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getItemDetails(queryType, sectionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('DetailsScreen error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data;
          if (item == null) {
            // ignore: avoid_print
            print('No item found for sectionId: $sectionId, type: $queryType');
            return const Center(child: Text('Item not found'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']?.toString() ?? 'Unknown',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (queryType == 'spell' && item['school'] != null) ...[
                    const SizedBox(height: 8),
                    Text('School: ${item['school']}'),
                  ],
                  if (queryType == 'spell' && item['level_text'] != null) ...[
                    const SizedBox(height: 8),
                    Text('Level: ${item['level_text']}'),
                  ],
                  if (queryType == 'skill' && item['attribute'] != null) ...[
                    const SizedBox(height: 8),
                    Text('Attribute: ${item['attribute']}'),
                  ],
                  if (item['source'] != null) ...[
                    const SizedBox(height: 8),
                    Text('Source: ${item['source']}'),
                  ],
                  if (item['description'] != null && item['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Description: ${item['description']}'),
                  ],
                  const SizedBox(height: 16),
                  Html(
                    data: item['body']?.toString() ?? '',
                    style: {
                      'body': Style(fontSize: FontSize(16)),
                      'table': Style(border: Border.all(color: Colors.grey)),
                      'a': Style(color: Colors.blue),
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _getItemDetails(String type, String sectionId) async {
    final db = await DatabaseHelper().getDatabase('book-cr.db');
    String query;
    if (type == 'spell') {
      query = '''
        SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
               sd.school, sd.level_text
        FROM sections s
        LEFT JOIN spell_details sd ON s.section_id = sd.section_id
        WHERE s.section_id = ?
      ''';
    } else if (type == 'skill') {
      query = '''
        SELECT s.section_id, s.name, s.description, s.body, s.source, s.type, 
               sa.attribute, sa.armor_check_penalty, sa.trained_only
        FROM sections s
        LEFT JOIN skill_attributes sa ON s.section_id = sa.section_id
        WHERE s.section_id = ?
      ''';
    } else {
      query = '''
        SELECT section_id, name, description, body, source, type
        FROM sections
        WHERE section_id = ?
      ''';
    }
    final results = await db.rawQuery(query, [sectionId]);
    return results.isNotEmpty ? results.first : null;
  }
}