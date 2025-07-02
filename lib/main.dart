import 'package:flutter/material.dart';
import 'package:psrd_compendium/screens/feat_list_screen.dart';
import 'package:psrd_compendium/screens/spell_list_screen.dart';
import 'package:psrd_compendium/screens/class_list_screen.dart';
import 'package:psrd_compendium/screens/creature_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSRD Compendium',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/feats': (context) => const FeatListScreen(),
        '/spells': (context) => const SpellListScreen(),
        '/classes': (context) => const ClassListScreen(),
        '/creatures': (context) => const CreatureListScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Compendium')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/spells'),
              child: const Text('Spells'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/feats'),
              child: const Text('Feats'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/classes'),
              child: const Text('Classes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/creatures'),
              child: const Text('Creatures'),
            ),
          ],
        ),
      ),
    );
  }
}