import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class RaceListScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const RaceListScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Races')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getSections('race'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading races'));
          }
          final races = snapshot.data ?? [];
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return ListTile(
                title: Text(race['name']),
                onTap: () {
                  // Navigate to race details (TBD)
                },
              );
            },
          );
        },
      ),
    );
  }
}