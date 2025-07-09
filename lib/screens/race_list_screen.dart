import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';

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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final races = snapshot.data!;
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return ListTile(
                title: Text(race['name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/race_details',
                    arguments: {'id': race['_id'].toString(), 'dbName': 'book-cr.db'},
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