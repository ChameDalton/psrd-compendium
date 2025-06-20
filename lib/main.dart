import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/screens/category_screen.dart';
import 'package:pathfinder_athenaeum/screens/details_screen.dart';
import 'package:pathfinder_athenaeum/screens/search_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().logSchema(); // Add this line
  runApp(PathfinderApp());
}

class PathfinderApp extends StatelessWidget {
  PathfinderApp({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CategoryListScreen(),
      ),
      GoRoute(
        path: '/category/:type',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          return CategoryScreen(type: type);
        },
      ),
      GoRoute(
        path: '/category/:type/:sectionId',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final sectionId = state.pathParameters['sectionId']!;
          return DetailsScreen(type: type, sectionId: sectionId);
        },
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
      ),
      routerConfig: _router,
    );
  }
}

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  static const List<String> _categories = [
    'Spells',
    'Feats',
    'Creatures',
    'Classes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pathfinder Compendium'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/search');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category),
            onTap: () {
              context.push('/category/$category');
            },
          );
        },
      ),
    );
  }
}