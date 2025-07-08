import 'package:flutter/material.dart';
import 'db/db_wrangler.dart';
import 'screens/bookmark_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbWrangler = DbWrangler();
  await dbWrangler.initializeDatabases();
  runApp(MainApp(dbWrangler: dbWrangler));
}

class MainApp extends StatelessWidget {
  final DbWrangler dbWrangler;

  MainApp({required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(dbWrangler: dbWrangler),
      routes: {
        '/bookmarks': (context) => BookmarkScreen(dbWrangler.getUserDatabase()),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  HomeScreen({required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pathfinder Compendium')),
      body: Center(child: Text('Welcome to the Pathfinder Compendium!')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu')),
            ListTile(
              title: Text('Bookmarks'),
              onTap: () {
                Navigator.pushNamed(context, '/bookmarks');
              },
            ),
          ],
        ),
      ),
    );
  }
}