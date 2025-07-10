import 'package:flutter/material.dart';
import 'db/db_wrangler.dart';
import 'services/database_helper.dart';
import 'screens/bookmark_screen.dart';
import 'screens/class_list_screen.dart';
import 'screens/class_details_screen.dart';
import 'screens/creature_list_screen.dart';
import 'screens/creature_details_screen.dart';
import 'screens/feat_list_screen.dart';
import 'screens/feat_details_screen.dart';
import 'screens/race_list_screen.dart';
import 'screens/race_details_screen.dart';
import 'screens/spell_list_screen.dart';
import 'screens/spell_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbWrangler = DbWrangler();
  await dbWrangler.initializeDatabases();
  runApp(MainApp(dbWrangler: dbWrangler));
}

class MainApp extends StatelessWidget {
  final DbWrangler dbWrangler;

  const MainApp({super.key, required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(dbWrangler: dbWrangler),
      routes: {
        '/bookmarks': (context) => BookmarkScreen(userDb: dbWrangler.getUserDatabase()),
        '/classes': (context) => ClassListScreen(dbHelper: dbWrangler),
        '/class_details': (context) => ClassDetailsScreen(dbHelper: dbWrangler),
        '/creatures': (context) => CreatureListScreen(dbHelper: dbWrangler),
        '/creature_details': (context) => CreatureDetailsScreen(dbHelper: dbWrangler),
        '/feats': (context) => FeatListScreen(dbHelper: dbWrangler),
        '/feat_details': (context) => FeatDetailsScreen(dbHelper: dbWrangler),
        '/races': (context) => RaceListScreen(dbHelper: dbWrangler),
        '/race_details': (context) => RaceDetailsScreen(dbHelper: dbWrangler),
        '/spells': (context) => SpellListScreen(dbHelper: dbWrangler),
        '/spell_details': (context) => SpellDetailsScreen(dbHelper: dbWrangler),
      },
      onGenerateRoute: (settings) async {
        if (settings.name?.startsWith('pfsrd://') ?? false) {
          final uri = Uri.parse(settings.name!);
          final pathSegments = uri.pathSegments;
          if (pathSegments.isNotEmpty) {
            final type = pathSegments[0].toLowerCase();
            final name = pathSegments.length > 1 ? pathSegments[1] : '';
            String route;
            final db = await dbWrangler.getIndexDatabase();
            final sections = await db.query(
              'central_index',
              where: 'Type = ? AND Name = ?',
              whereArgs: [type, name],
              limit: 1,
            );
            if (sections.isEmpty) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Item not found')),
                ),
              );
            }
            final section = sections.first;
            final dbName = section['Database'] as String;
            final sectionId = section['Section_id'].toString();

            switch (type) {
              case 'spell':
                route = '/spell_details';
                break;
              case 'class':
                route = '/class_details';
                break;
              case 'feat':
                route = '/feat_details';
                break;
              case 'race':
                route = '/race_details';
                break;
              case 'creature':
                route = '/creature_details';
                break;
              default:
                return null;
            }
            return MaterialPageRoute(
              builder: (context) => _getDetailScreen(route, dbWrangler),
              settings: RouteSettings(
                name: route,
                arguments: {'id': sectionId, 'dbName': dbName},
              ),
            );
          }
        }
        return null;
      },
    );
  }

  Widget _getDetailScreen(String route, DbWrangler dbWrangler) {
    switch (route) {
      case '/spell_details':
        return SpellDetailsScreen(dbHelper: dbWrangler);
      case '/class_details':
        return ClassDetailsScreen(dbHelper: dbWrangler);
      case '/feat_details':
        return FeatDetailsScreen(dbHelper: dbWrangler);
      case '/race_details':
        return RaceDetailsScreen(dbHelper: dbWrangler);
      case '/creature_details':
        return CreatureDetailsScreen(dbHelper: dbWrangler);
      default:
        return const Scaffold(body: Center(child: Text('Unknown route')));
    }
  }
}

class HomeScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const HomeScreen({super.key, required this.dbWrangler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Compendium')),
      body: const Center(child: Text('Welcome to the Pathfinder Compendium!')),
      drawer: Drawer(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().getMenuItems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading menu'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final menuItems = snapshot.data!;
            return ListView(
              children: [
                const DrawerHeader(child: Text('Menu')),
                ...menuItems.map((item) => _buildMenuItem(context, item)).toList(),
              ],
            );
          },
        ),
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
            return ListTile(title: Text(item['Name']), subtitle: const Text('Error loading subitems'));
          }
          if (!snapshot.hasData) {
            return ListTile(title: Text(item['Name']), trailing: const CircularProgressIndicator());
          }
          final subItems = snapshot.data!;
          return ExpansionTile(
            title: Text(item['Name']),
            children: subItems.map((subItem) {
              return ListTile(
                title: Text(subItem['Name']),
                onTap: () {
                  Navigator.pushNamed(context, subItem['Url'] ?? '/');
                },
              );
            }).toList(),
          );
        },
      );
    }
    return ListTile(
      title: Text(item['Name']),
      onTap: () {
        Navigator.pushNamed(context, item['Url'] ?? '/');
      },
    );
  }
}