// lib/screens/class_detail_screen.dart
import 'package:flutter/material.dart';
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(item['description'] ?? 'No description', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Source: ${item['source'] ?? 'Unknown'}'),
                const SizedBox(height: 8),
                Text('Body: ${item['body'] ?? 'No details'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}