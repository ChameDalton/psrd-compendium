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

  const MainApp({Key? key, required this.dbWrangler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(dbWrangler: dbWrangler),
      routes: {
        '/bookmarks': (context) => BookmarkScreen(userDb: dbWrangler.getUserDatabase()),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const HomeScreen({Key? key, required this.dbWrangler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBar(title: Text('Pathfinder Compendium')),
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
          ],
        ),
      ),
    );
  }
}