import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/bookmark_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/creature_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  final DbWrangler _dbWrangler = DbWrangler();

  @override
  void initState() {
    super.initState();
    _dbWrangler.initializeDatabases();
  }

  @override
  void dispose() {
    _dbWrangler.closeDatabases();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(dbWrangler: _dbWrangler),
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        final path = uri.path;
        final queryParameters = uri.queryParameters;

        if (path == '/classes') {
          return MaterialPageRoute(
            builder: (context) => ClassListScreen(dbHelper: _dbWrangler),
          );
        } else if (path == '/creatures') {
          return MaterialPageRoute(
            builder: (context) => CreatureListScreen(dbHelper: _dbWrangler),
          );
        } else if (path == '/feats') {
          return MaterialPageRoute(
            builder: (context) => FeatListScreen(dbHelper: _dbWrangler),
          );
        } else if (path == '/races') {
          return MaterialPageRoute(
            builder: (context) => RaceListScreen(dbHelper: _dbWrangler),
          );
        } else if (path == '/spells') {
          return MaterialPageRoute(
            builder: (context) => SpellListScreen(dbHelper: _dbWrangler),
          );
        } else if (path == '/bookmarks') {
          return MaterialPageRoute(
            builder: (context) => BookmarkScreen(dbWrangler: _dbWrangler),
          );
        } else if (path.startsWith('/class/')) {
          final sectionId = int.parse(queryParameters['section_id'] ?? '0');
          final dbName = queryParameters['db'] ?? 'index.db';
          return MaterialPageRoute(
            builder: (context) => ClassDetailsScreen(sectionId: sectionId, dbName: dbName),
          );
        } else if (path.startsWith('/creature/')) {
          final sectionId = int.parse(queryParameters['section_id'] ?? '0');
          final dbName = queryParameters['db'] ?? 'index.db';
          return MaterialPageRoute(
            builder: (context) => CreatureDetailsScreen(sectionId: sectionId, dbName: dbName),
          );
        } else if (path.startsWith('/feat/')) {
          final sectionId = int.parse(queryParameters['section_id'] ?? '0');
          final dbName = queryParameters['db'] ?? 'index.db';
          return MaterialPageRoute(
            builder: (context) => FeatDetailsScreen(sectionId: sectionId, dbName: dbName),
          );
        } else if (path.startsWith('/race/')) {
          final sectionId = int.parse(queryParameters['section_id'] ?? '0');
          final dbName = queryParameters['db'] ?? 'index.db';
          return MaterialPageRoute(
            builder: (context) => RaceDetailsScreen(sectionId: sectionId, dbName: dbName),
          );
        } else if (path.startsWith('/spell/')) {
          final spellId = int.parse(queryParameters['spell_id'] ?? '0');
          final dbName = queryParameters['db'] ?? 'index.db';
          return MaterialPageRoute(
            builder: (context) => SpellDetailsScreen(spellId: spellId, dbName: dbName),
          );
        }
        return MaterialPageRoute(builder: (context) => HomeScreen(dbWrangler: _dbWrangler));
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const HomeScreen({super.key, required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Athenaeum')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getMenuItems(parentMenuId: null),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading menu'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final menuItems = snapshot.data!;
          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return _buildMenuItem(context, menuItems[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    final hasSubItems = item['Type'] == null || item['Type'].isEmpty;
    if (hasSubItems) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getMenuItems(parentMenuId: item['Menu_id']),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListTile(title: Text(item['Name'] ?? 'Unknown'), subtitle: const Text('Error loading subitems'));
          }
          if (!snapshot.hasData) {
            return ListTile(title: Text(item['Name'] ?? 'Unknown'), trailing: const CircularProgressIndicator());
          }
          final subItems = snapshot.data!;
          return ExpansionTile(
            title: Text(item['Name'] ?? 'Unknown'),
            children: subItems.map((subItem) {
              return ListTile(
                title: Text(subItem['Name'] ?? 'Unknown'),
                onTap: subItem['Url'] != null
                    ? () {
                        Navigator.pushNamed(context, subItem['Url'] as String);
                      }
                    : null,
              );
            }).toList(),
          );
        },
      );
    }
    return ListTile(
      title: Text(item['Name'] ?? 'Unknown'),
      onTap: item['Url'] != null
          ? () {
              Navigator.pushNamed(context, item['Url'] as String);
            }
          : null,
    );
  }
}