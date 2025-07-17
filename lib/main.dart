import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/bookmark_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';

void main() {
  runApp(MyApp(dbWrangler: DbWrangler()));
}

class MyApp extends StatelessWidget {
  final DbWrangler dbWrangler;

  const MyApp({required this.dbWrangler, super.key});

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/classes':
        return MaterialPageRoute(
          builder: (_) => ClassListScreen(dbWrangler: dbWrangler),
        );
      case '/creatures':
        return MaterialPageRoute(
          builder: (_) => CreatureListScreen(dbWrangler: dbWrangler),
        );
      case '/feats':
        return MaterialPageRoute(
          builder: (_) => FeatListScreen(dbWrangler: dbWrangler),
        );
      case '/races':
        return MaterialPageRoute(
          builder: (_) => RaceListScreen(dbWrangler: dbWrangler),
        );
      case '/spells':
        return MaterialPageRoute(
          builder: (_) => SpellListScreen(dbWrangler: dbWrangler),
        );
      case '/bookmarks':
        return MaterialPageRoute(
          builder: (_) => BookmarkScreen(dbWrangler: dbWrangler),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/classes',
      onGenerateRoute: generateRoute,
    );
  }
}