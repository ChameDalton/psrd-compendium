import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class SpellListScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const SpellListScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spells')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getSections('spell'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading spells'));
          }
          final spells = snapshot.data ?? [];
          return ListView.builder(
            itemCount: spells.length,
            itemBuilder: (context, index) {
              final spell = spells[index];
              return ListTile(
                title: Text(spell['name']),
                onTap: () {
                  // Navigate to spell details (TBD)
                },
              );
            },
          );
        },
      ),
    );
  }
}