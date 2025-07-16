import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class CreatureListScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const CreatureListScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creatures')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getSections('creature'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading creatures'));
          }
          final creatures = snapshot.data ?? [];
          return ListView.builder(
            itemCount: creatures.length,
            itemBuilder: (context, index) {
              final creature = creatures[index];
              return ListTile(
                title: Text(creature['name']),
                onTap: () {
                  // Navigate to creature details (TBD)
                },
              );
            },
          );
        },
      ),
    );
  }
}