import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';

class ClassListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const ClassListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'class'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading classes'));
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
                    '/class/${section['Section_id']}?db=${section['Database']}§ion_id=${section['Section_id']}',
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