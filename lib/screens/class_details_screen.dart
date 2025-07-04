import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class ClassDetailsScreen extends StatelessWidget {
  final String classId;
  final DatabaseHelper dbHelper;

  const ClassDetailsScreen({
    super.key,
    required this.classId,
    required this.dbHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: dbHelper.getSectionWithSubsections(context, classId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Error in ClassDetailsScreen: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            debugPrint('No data found for classId: $classId');
            return const Center(child: Text('No data found'));
          }

          final data = snapshot.data!;
          final section = data['section'] as Map<String, dynamic>;
          final subsections = data['subsections'] as List<Map<String, dynamic>>;
          debugPrint('ClassDetailsScreen data: section=${section['name']}, source=${section['source']}, subsections=${subsections.length}');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section['name'] ?? 'Unknown Class',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8.0),
                if (section['source'] != null)
                  Text(
                    'Source: ${section['source']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                const SizedBox(height: 8.0),
                if (section['description'] != null)
                  Text(
                    'Description: ${section['description']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                const SizedBox(height: 8.0),
                if (section['body'] != null)
                  Html(
                    data: section['body'],
                    style: {
                      'body': Style(
                        fontSize: FontSize(16.0),
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    },
                  ),
                if (subsections.isNotEmpty) ...[
                  const SizedBox(height: 16.0),
                  Text(
                    'Subsections',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ...subsections.map((subsection) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subsection['name'] ?? 'Untitled',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Html(
                              data: subsection['body'] ?? '',
                              style: {
                                'body': Style(
                                  fontSize: FontSize(16.0),
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              },
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}