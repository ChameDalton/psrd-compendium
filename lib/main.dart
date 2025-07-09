import 'package:flutter/material.dart';
import 'db/db_wrangler.dart';
import 'screens/bookmark_screen.dart';
import 'screens/class_list_screen.dart';
import 'screens/class_details_screen.dart';
import 'screens/feat_list_screen.dart';
import 'screens/feat_details_screen.dart';
import 'screens/race_list_screen.dart';
import 'screens/race_details_screen.dart';
import 'screens/spell_list_screen.dart';
import 'screens/spell_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbWrangler = DbWrangler();
  await dbWrangler.initializeDatabases();
  runApp(MainApp(dbWrangler: dbWrangler));
}

class MainApp extends StatelessWidget {
  final DbWrangler dbWrangler;

  const MainApp({super.key, required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(dbWrangler: dbWrangler),
      routes: {
        '/bookmarks': (context) => BookmarkScreen(userDb: dbWrangler.getUserDatabase()),
        '/classes': (context) => ClassListScreen(dbHelper: dbWrangler),
        '/class_details': (context) => ClassDetailsScreen(dbHelper: dbWrangler),
        '/feats': (context) => FeatListScreen(dbHelper: dbWrangler),
        '/feat_details': (context) => FeatDetailsScreen(dbHelper: dbWrangler),
        '/races': (context) => RaceListScreen(dbHelper: dbWrangler),
        '/race_details': (context) => RaceDetailsScreen(dbHelper: dbWrangler),
        '/spells': (context) => SpellListScreen(dbHelper: dbWrangler),
        '/spell_details': (context) => SpellDetailsScreen(dbHelper: dbWrangler),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const HomeScreen({super.key, required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Compendium')),
      body: const Center(child: Text('Welcome to the Pathfinder Compendium!')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Bookmarks'),
              onTap: () {
                Navigator.pushNamed(context, '/bookmarks');
              },
            ),
            ListTile(
              title: const Text('Classes'),
              onTap: () {
                Navigator.pushNamed(context, '/classes');
              },
            ),
            ListTile(
              title: const Text('Feats'),
              onTap: () {
                Navigator.pushNamed(context, '/feats');
              },
            ),
            ListTile(
              title: const Text('Races'),
              onTap: () {
                Navigator.pushNamed(context, '/races');
              },
            ),
            ListTile(
              title: const Text('Spells'),
              onTap: () {
                Navigator.pushNamed(context, '/spells');
              },
            ),
          ],
        ),
      ),
    );
  }
}