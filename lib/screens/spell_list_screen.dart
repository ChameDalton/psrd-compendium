import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';

class SpellListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const SpellListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spells'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSections(context, 'spell'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No spells found'));
          }

          final spells = snapshot.data!;
          return ListView.builder(
            itemCount: spells.length,
            itemBuilder: (context, index) {
              final spell = spells[index];
              return ListTile(
                title: Text(spell['name'] ?? 'Unknown Spell'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpellDetailsScreen(
                        dbHelper: dbHelper,
                        sectionId: spell['section_id'].toString(),
                        spellName: spell['name'].toString(),
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