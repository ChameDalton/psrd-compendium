import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/bookmark_screen.dart';

class MainScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const MainScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pathfinder Athenaeum'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Classes'),
              Tab(text: 'Creatures'),
              Tab(text: 'Feats'),
              Tab(text: 'Races'),
              Tab(text: 'Spells'),
              Tab(text: 'Bookmarks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ClassListScreen(dbWrangler: dbWrangler),
            CreatureListScreen(dbWrangler: dbWrangler),
            FeatListScreen(dbWrangler: dbWrangler),
            RaceListScreen(dbWrangler: dbWrangler),
            SpellListScreen(dbWrangler: dbWrangler),
            BookmarkScreen(dbWrangler: dbWrangler),
          ],
        ),
      ),
    );
  }
}