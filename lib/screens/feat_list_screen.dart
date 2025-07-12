import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';

class FeatListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const FeatListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feats')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'feat'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading feats'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final sections = snapshot.data!;
          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              return ListTile(
                title: Text(section['Name'] ?? 'Unknown'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/feat/${section['Section_id']}?db=${section['Database']}§ion_id=${section['Section_id']}',
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}