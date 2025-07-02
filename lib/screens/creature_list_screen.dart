import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/creature_details_screen.dart';

class CreatureListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const CreatureListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creatures')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSections(context, 'creature'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No creatures found'));
          }
          final creatures = snapshot.data!;
          return ListView.builder(
            itemCount: creatures.length,
            itemBuilder: (context, index) {
              final creature = creatures[index];
              return ListTile(
                title: Text(creature['name'] ?? 'Unknown'),
                subtitle: Text(creature['source'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatureDetailsScreen(
                        creatureId: creature['section_id'].toString(),
                        dbHelper: dbHelper,
                      ),
                    ),
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