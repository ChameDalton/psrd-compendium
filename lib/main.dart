import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(dbHelper: dbHelper),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const HomeScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Athenaeum')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeatListScreen(dbHelper: dbHelper),
                  ),
                );
              },
              child: const Text('Feats'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpellListScreen(dbHelper: dbHelper),
                  ),
                );
              },
              child: const Text('Spells'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassListScreen(dbHelper: dbHelper),
                  ),
                );
              },
              child: const Text('Classes'),
            ),
            const Tooltip(
              message: 'Creatures not yet supported (requires b1.db)',
              child: ElevatedButton(
                onPressed: null, // Disabled until creatures database is confirmed
                child: Text('Creatures'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}