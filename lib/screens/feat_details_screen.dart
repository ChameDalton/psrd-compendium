import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class FeatDetailsScreen extends StatelessWidget {
  final String featId;
  final DatabaseHelper dbHelper;

  const FeatDetailsScreen({super.key, required this.featId, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feat Details')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSectionDetails(featId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No details found'));
          }
          final details = snapshot.data!;
          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final detail = details[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(data: detail['body'] ?? 'No content'),
              );
            },
          );
        },
      ),
    );
  }
}