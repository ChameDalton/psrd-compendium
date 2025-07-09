import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';

class SpellListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const SpellListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spells')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'spell'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final spells = snapshot.data!;
          return ListView.builder(
            itemCount: spells.length,
            itemBuilder: (context, index) {
              final spell = spells[index];
              return ListTile(
                title: Text(spell['name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/spell_details',
                    arguments: {'id': spell['_id'].toString(), 'dbName': 'book-cr.db'},
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