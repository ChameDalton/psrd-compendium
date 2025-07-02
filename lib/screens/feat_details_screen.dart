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
      body: FutureBuilder<Map<String, dynamic>>(
        future: dbHelper.getSectionWithSubsections(featId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!['section'] == null) {
            return const Center(child: Text('No details found'));
          }
          final data = snapshot.data!;
          final section = data['section'] as Map<String, dynamic>;
          final subsections = data['subsections'] as List<dynamic>;

          return ListView(
            children: [
              if (section['body'] != null && section['body'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(data: section['body']),
                ),
              ...subsections.map((subsection) {
                final subData = subsection['section'] as Map<String, dynamic>;
                final subSubsections = subsection['subsections'] as List<dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subData['body'] != null && subData['body'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(data: subData['body']),
                      ),
                    ...subSubsections.map((subSubsection) {
                      final subSubData = subSubsection['section'] as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0, right: 8.0),
                        child: Html(data: subSubData['body'] ?? ''),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}