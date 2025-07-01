import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/screens/class_detail_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/details_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/home_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

void main() {
  runApp(const PathfinderApp());
}

class PathfinderApp extends StatelessWidget {
  const PathfinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/category/spell',
          builder: (context, state) => const SpellListScreen(),
        ),
        GoRoute(
          path: '/category/feat',
          builder: (context, state) => FeatListScreen(),
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
          path: '/category/:type/:sectionId',
          builder: (context, state) {
            final type = state.pathParameters['type']!;
            final sectionId = state.pathParameters['sectionId']!;
            return DetailsScreen(type: type, sectionId: sectionId);
          },
        ),
        GoRoute(
          path: '/class/:sectionId',
          builder: (context, state) {
            final sectionId = state.pathParameters['sectionId']!;
            return ClassDetailScreen(sectionId: sectionId);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Pathfinder Compendium',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}