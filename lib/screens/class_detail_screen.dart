import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class ClassDetailScreen extends StatelessWidget {
  final String sectionId;

  const ClassDetailScreen({super.key, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Details')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getItemBySectionId(sectionId, dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('ClassDetailScreen error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data;
          if (item == null) {
            return const Center(child: Text('Class not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                if (item['description'] != null && item['description'].isNotEmpty)
                  Text(item['description'], style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Source: ${item['source'] ?? 'Unknown'}'),
                const SizedBox(height: 8),
                if (item['body'] != null && item['body'].isNotEmpty)
                  Html(data: item['body']),
                if (item['body'] == null || item['body'].isEmpty)
                  const Text('Body: No details'),
              ],
            ),
          );
        },
      ),
    );
  }
}