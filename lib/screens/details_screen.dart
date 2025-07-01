import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class DetailsScreen extends StatelessWidget {
  final String sectionId;
  final String type;

  const DetailsScreen({super.key, required this.sectionId, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${type[0].toUpperCase()}${type.substring(1)} Details')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getItemBySectionId(sectionId, dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('DetailsScreen error for $type: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data;
          if (item == null) {
            return Center(child: Text('$type not found'));
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
                if (item['feat_type'] != null)
                  Text('Feat Type: ${item['feat_type']}'),
                if (item['prerequisites'] != null)
                  Text('Prerequisites: ${item['prerequisites']}'),
                if (item['school'] != null)
                  Text('School: ${item['school']}'),
                if (item['subschool'] != null)
                  Text('Subschool: ${item['subschool']}'),
                if (item['descriptor'] != null)
                  Text('Descriptor: ${item['descriptor']}'),
                if (item['level_text'] != null)
                  Text('Level: ${item['level_text']}'),
                if (item['challenge_rating'] != null)
                  Text('Challenge Rating: ${item['challenge_rating']}'),
                if (item['size'] != null)
                  Text('Size: ${item['size']}'),
                if (item['alignment'] != null)
                  Text('Alignment: ${item['alignment']}'),
                if (item['attribute'] != null)
                  Text('Attribute: ${item['attribute']}'),
                if (item['armor_check_penalty'] != null)
                  Text('Armor Check Penalty: ${item['armor_check_penalty']}'),
                if (item['trained_only'] != null)
                  Text('Trained Only: ${item['trained_only']}'),
                const SizedBox(height: 8),
                if (item['body'] != null && item['body'].isNotEmpty)
                  Html(
                    data: item['body'],
                    style: {
                      "p": Style(fontSize: FontSize(16)),
                      "b": Style(fontWeight: FontWeight.bold),
                      "table": Style(border: Border.all(color: Colors.grey)),
                      "td": Style(border: Border.all(color: Colors.grey)),
                    },
                  ),
                if (item['body'] == null || item['body'].isEmpty)
                  Text(
                    type == 'feat' && item['prerequisites'] != null
                        ? 'Details: ${item['prerequisites']}'
                        : 'Body: No details',
                  ),
                if (item['child_body'] != null && item['child_body'].isNotEmpty)
                  Text('Child Body: ${item['child_body']}', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}