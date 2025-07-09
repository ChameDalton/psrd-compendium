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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final creatures = snapshot.data!;
          return ListView.builder(
            itemCount: creatures.length,
            itemBuilder: (context, index) {
              final creature = creatures[index];
              return ListTile(
                title: Text(creature['name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/creature_details',
                    arguments: {'id': creature['_id'].toString(), 'dbName': 'book-b1.db'},
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