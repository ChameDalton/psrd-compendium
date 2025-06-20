import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/screens/category_screen.dart';
import 'package:pathfinder_athenaeum/screens/details_screen.dart';
import 'package:pathfinder_athenaeum/screens/search_screen.dart';

void main() {
  runApp(PathfinderApp());
}

class PathfinderApp extends StatelessWidget {
  PathfinderApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/category/:type',
        builder: (context, state) => CategoryScreen(type: state.pathParameters['type']!),
      ),
      GoRoute(
        path: '/category/:type/:sectionId',
        builder: (context, state) => DetailsScreen(
          type: state.pathParameters['type']!,
          sectionId: state.pathParameters['sectionId']!,
        ),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pathfinder Compendium',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          leadingWidth: 56,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final categories = const ['Spells', 'Feats', 'Creatures', 'Classes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pathfinder Compendium'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => context.push('/category/${category.toLowerCase()}'),
          );
        },
      ),
    );
  }
}