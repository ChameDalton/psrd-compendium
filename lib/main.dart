import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/screens/bookmark_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:sqflite_common/sqlite_api.dart';

void main() {
  runApp(MainApp(dbWrangler: DbWrangler()));
}

class MainApp extends StatelessWidget {
  final DbWrangler dbWrangler;

  const MainApp({super.key, required this.dbWrangler});

  static Route<dynamic> generateRoute(DbWrangler dbWrangler) {
    return (RouteSettings settings) {
      final uri = Uri.parse(settings.name ?? '/');
      final pathSegments = uri.pathSegments;

      if (pathSegments.isEmpty || pathSegments[0] == 'classes') {
        return MaterialPageRoute(
          builder: (context) => ClassListScreen(dbHelper: dbWrangler),
          settings: settings,
        );
      }

      if (pathSegments[0] == 'creatures') {
        return MaterialPageRoute(
          builder: (context) => CreatureListScreen(dbHelper: dbWrangler),
          settings: settings,
        );
      }

      if (pathSegments[0] == 'feats') {
        return MaterialPageRoute(
          builder: (context) => FeatListScreen(dbHelper: dbWrangler),
          settings: settings,
        );
      }

      if (pathSegments[0] == 'races') {
        return MaterialPageRoute(
          builder: (context) => RaceListScreen(dbHelper: dbWrangler),
          settings: settings,
        );
      }

      if (pathSegments[0] == 'spells') {
        return MaterialPageRoute(
          builder: (context) => SpellListScreen(dbHelper: dbWrangler),
          settings: settings,
        );
      }

      if (pathSegments[0] == 'bookmarks') {
        return MaterialPageRoute(
          builder: (context) => BookmarkScreen(userDb: dbWrangler.userDb),
          settings: settings,
        );
      }

      return MaterialPageRoute(
        builder: (context) => ClassListScreen(dbHelper: dbWrangler),
        settings: settings,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/classes',
      onGenerateRoute: generateRoute(dbWrangler),
    );
  }
}