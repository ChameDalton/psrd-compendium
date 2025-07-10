import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';
import '../services/database_helper.dart';

class RaceListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const RaceListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Races')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'race'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading races. Please check database.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final races = snapshot.data!;
          if (races.isEmpty) {
            return const Center(child: Text('No races found.'));
          }
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return ListTile(
                title: Text(race['Name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/race_details',
                    arguments: {
                      'id': race['Section_id'].toString(),
                      'dbName': race['Database'],
                    },
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