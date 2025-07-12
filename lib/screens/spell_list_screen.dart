import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';

class SpellListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const SpellListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spells')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'spell'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading spells'));
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
                    '/spell/${section['Section_id']}?db=${section['Database']}&spell_id=${section['Section_id']}',
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