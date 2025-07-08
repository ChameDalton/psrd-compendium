import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class RaceListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const RaceListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Races'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSections(context, 'race'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Error in RaceListScreen: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('No races found');
            return const Center(child: Text('No races found'));
          }

          final races = snapshot.data!;

          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return ListTile(
                title: Text(race['name'] ?? 'Unknown Race'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/race_details',
                    arguments: race['section_id'].toString(),
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