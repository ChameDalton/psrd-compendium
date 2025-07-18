import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const HomeScreen({required this.dbWrangler, super.key});

  // Map section names to their routes and types
  static const Map<String, Map<String, String>> sectionRoutes = {
    'Classes': {'route': '/classes', 'type': 'class'},
    'Creatures': {'route': '/creatures', 'type': 'creature'},
    'Feats': {'route': '/feats', 'type': 'feat'},
    'Races': {'route': '/races', 'type': 'race'},
    'Spells': {'route': '/spells', 'type': 'spell'},
    'Skills': {'route': '/skills', 'type': 'skill'},
    'Rules': {'route': '/rules', 'type': 'rule'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Athenaeum')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getSections(context, 'start'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sections found'));
          }

          final sections = snapshot.data!;
          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              final name = section['name'] ?? 'Unknown';
              final type = section['type'] ?? '';
              final route = sectionRoutes[name]?['route'] ?? '/';

              return ListTile(
                title: Text(name),
                onTap: () {
                  Navigator.pushNamed(context, route);
                },
              );
            },
          );
        },
      ),
    );
  }
}