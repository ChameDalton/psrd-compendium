import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/detail_screen.dart';

class SpellListScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const SpellListScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbWrangler.getSections(context, 'race'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No spells found'));
        }

        final sections = snapshot.data!;
        return ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return ListTile(
              title: Text(section['name'] ?? 'Unknown'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {'name': section['name'], 'url': section['url']},
                );
              },
            );
          },
        );
      },
    );
  }
}