import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class SpellListScreen extends StatelessWidget {
  const SpellListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spells')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getSections('spell'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No spells found'));
          }
          final spells = snapshot.data!;
          return ListView.builder(
            itemCount: spells.length,
            itemBuilder: (context, index) {
              final spell = spells[index];
              return ListTile(
                title: Text(spell['name'] ?? 'Unknown'),
                subtitle: Text(spell['source'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: Text(spell['name'] ?? 'Details')),
                        body: const Center(child: Text('Spell details TBD')),
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