import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/screens/class_detail_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/details_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

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
        return DetailsScreen(sectionId: id, type: type);
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
  const PathfinderApp({super.key});

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