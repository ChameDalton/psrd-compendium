import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class FeatDetailsScreen extends StatelessWidget {
  final int sectionId;
  final String dbName;

  const FeatDetailsScreen({super.key, required this.sectionId, required this.dbName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feat Details')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getSectionWithSubsections(dbName, sectionId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading details'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final section = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(section['body'] ?? ''),
                  if (section['subsections'] != null)
                    ...section['subsections'].map<Widget>((sub) => Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sub['name'] ?? 'Unknown', style: Theme.of(context).textTheme.titleMedium),
                              Text(sub['body'] ?? ''),
                            ],
                          ),
                        )).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}