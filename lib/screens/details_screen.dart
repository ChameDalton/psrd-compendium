import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class DetailsScreen extends StatelessWidget {
  final String type;
  final String sectionId;

  const DetailsScreen({super.key, required this.type, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('DetailsScreen: type=$type, sectionId=$sectionId');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getItemBySectionId(sectionId, dbName: 'book-cr.db'),
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
            print('No item found for sectionId: $sectionId, type: $type');
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
                  if (item['source'] != null) ...[
                    const SizedBox(height: 8),
                    Text('Source: ${item['source']}'),
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