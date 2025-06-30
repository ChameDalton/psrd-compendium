import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/screens/class_detail_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

// Generic DetailScreen for feats, spells, creatures
class DetailScreen extends StatelessWidget {
  final String sectionId;
  final String type;

  const DetailScreen({super.key, required this.sectionId, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${type[0].toUpperCase()}${type.substring(1)} Details')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getItemBySectionId(sectionId, dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('DetailScreen error for $type: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data;
          if (item == null) {
            return Center(child: Text('$type not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(item['description'] ?? 'No description', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Source: ${item['source'] ?? 'Unknown'}'),
                const SizedBox(height: 8),
                Text('Body: ${item['body'] ?? 'No details'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Home screen
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
              onPressed: () => context.push('/category/feat'),
              child: const Text('Feats'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/category/spell'),
              child: const Text('Spells'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/category/creature'),
              child: const Text('Creatures'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/category/class'),
              child: const Text('Classes'),
            ),
          ],
        ),
      ),
    );
  }
}

// Router configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/category/feat',
      builder: (context, state) => const FeatListScreen(),
    ),
    GoRoute(
      path: '/category/spell',
      builder: (context, state) => const SpellListScreen(),
    ),
    GoRoute(
      path: '/category/creature',
      builder: (context, state) => const CreatureListScreen(),
    ),
    GoRoute(
      path: '/category/class',
      builder: (context, state) => const ClassListScreen(),
    ),
    GoRoute(
      path: '/category/:type/:id',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final id = state.pathParameters['id']!;
        if (type == 'class') {
          return ClassDetailScreen(sectionId: id);
        }
        return DetailScreen(sectionId: id, type: type);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.uri}')),
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper().logSchema();
  runApp(PathfinderApp());
}

class PathfinderApp extends StatelessWidget {
  PathfinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pathfinder Compendium',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}