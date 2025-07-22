import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/bookmark_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Athenaeum')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Spells'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SpellListScreen()),
            ),
          ),
          ListTile(
            title: const Text('Classes'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClassListScreen()),
            ),
          ),
          ListTile(
            title: const Text('Feats'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeatListScreen()),
            ),
          ),
          ListTile(
            title: const Text('Races'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RaceListScreen()),
            ),
          ),
          ListTile(
            title: const Text('Creatures'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatureListScreen()),
            ),
          ),
          ListTile(
            title: const Text('Bookmarks'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookmarkScreen()),
            ),
          ),
        ],
      ),
    );
  }
}