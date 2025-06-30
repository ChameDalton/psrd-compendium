import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
// Add other screen imports as needed

// Define your GoRouter configuration (replace with your actual routes)
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FeatListScreen(), // Replace with your home screen
    ),
    GoRoute(
      path: '/category/feat/:id',
      builder: (context, state) => FeatListScreen(), // Adjust for detail screen
    ),
    GoRoute(
      path: '/category/spell/:id',
      builder: (context, state) => SpellListScreen(), // Adjust for detail screen
    ),
    GoRoute(
      path: '/category/class/:id',
      builder: (context, state) => ClassListScreen(), // Adjust for detail screen
    ),
    // Add routes for other categories (e.g., skills, creatures)
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper().logSchema();
  runApp(PathfinderApp());
}

class PathfinderApp extends StatelessWidget {
  PathfinderApp({super.key}); // Non-const constructor

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