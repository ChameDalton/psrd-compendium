import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class SpellDetailsScreen extends StatelessWidget {
  final int spellId;
  final String dbName;

  const SpellDetailsScreen({super.key, required this.spellId, required this.dbName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spell Details')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getSpellDetails(dbName, spellId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading spell details'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final spell = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spell['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(spell['description'] ?? ''),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}