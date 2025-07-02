import 'package:flutter/material.dart';
import 'package:psrd_compendium/database_helper.dart';

class CreatureListScreen extends StatelessWidget {
  const CreatureListScreen({super.key});

  @override
  Widget build(Build

Context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creatures')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getSections('creature'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No creatures found'));
          }
          final creatures = snapshot.data!;
          return ListView.builder(
            itemCount: creatures.length,
            itemBuilder: (context, index) {
              final creature = creatures[index];
              return ListTile(
                title: Text(creature['name'] ?? 'Unknown'),
                subtitle: Text(creature['source'] ?? ''),
                onTap: () {
                  // TODO: Implement CreatureDetailsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: Text(creature['name'] ?? 'Details')),
                        body: const Center(child: Text('Details screen TBD')),
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