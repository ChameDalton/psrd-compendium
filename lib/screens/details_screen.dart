import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:psrd_compendium/services/database_helper.dart';

class DetailsScreen extends StatelessWidget {
  final String type;
  final String sectionId;

  const DetailsScreen({super.key, required this.type, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getItemsByType(type, dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data?.firstWhere(
            (i) => i['section_id'].toString() == sectionId,
            orElse: () => {},
          );
          if (item == null || item.isEmpty) {
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
                  if (item['school'] != null) ...[
                    const SizedBox(height: 8),
                    Text('School: ${item['school']}'),
                  ],
                  if (item['level_text'] != null) ...[
                    const SizedBox(height: 8),
                    Text('Level: ${item['level_text']}'),
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
}