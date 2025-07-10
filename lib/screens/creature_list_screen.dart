import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';
import '../services/database_helper.dart';

class CreatureListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const CreatureListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creatures')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'creature'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading creatures. Please check database.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final creatures = snapshot.data!;
          if (creatures.isEmpty) {
            return const Center(child: Text('No creatures found.'));
          }
          return ListView.builder(
            itemCount: creatures.length,
            itemBuilder: (context, index) {
              final creature = creatures[index];
              return ListTile(
                title: Text(creature['Name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/creature_details',
                    arguments: {
                      'id': creature['Section_id'].toString(),
                      'dbName': creature['Database'],
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