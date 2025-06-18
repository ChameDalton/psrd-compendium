import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';
import 'services/database_helper_deprecated.dart';
import 'screens/feat_list_screen.dart';
import 'screens/skill_list_screen.dart';
import 'screens/spell_list_screen.dart';
import 'screens/creature_list_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures database operations run correctly.
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const MainMenuScreen(),
        '/database': (_) => const DatabaseTestScreen(),
        '/creatures': (_) => const CreatureListScreen(),
        '/feats': (_) => const FeatListScreen(),
        '/skills': (_) => const SkillListScreen(),
        '/spells': (_) => const SpellListScreen(),
      },
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Athenaeum')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Database Test'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/database'),
          ),
          ListTile(
            title: const Text('Feat List (Mock)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/feats'),
          ),
          ListTile(
            title: const Text('Skills (Mock)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/skills'),
          ),
          ListTile(
            title: const Text('Spells (Mock)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/spells'),
          ),
          ListTile(
            title: const Text('Creatures (Mock)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/creatures'),
          ),
        ],
      ),
    );
  }
}


//class MyApp extends StatelessWidget {
//  const MyApp({super.key});
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Pathfinder Athenaeum',
//      theme: ThemeData(
//        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//        useMaterial3: true, // Enables modern Material design
//      ),
//      home: const DatabaseTestScreen(),
//    );
//  }
//}

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  List<String> tableNames = [];

  @override
  void initState() {
    super.initState();
    loadTables();
    checkTables(); // Runs verification on app startup
    checkTableContents("class_details"); // Checks contents of all tables
    checkTableContents("feat_types"); // Checks contents of all tables
    checkTableContents("feat_type_descriptions"); // Checks contents of all tables
    checkTableContents("skill_attributes"); // Checks contents of all tables
  }

  Future<void> loadTables() async {
    final db = await DatabaseHelper.initDatabase();
    final tables = await DatabaseHelper.getTableNames(db);
    setState(() {
      tableNames = tables;
    });
  }
  List<Map<String, dynamic>> tableData = [];

  Future<void> checkTables() async {
    final db = await DatabaseHelper.initDatabase();
    final verifiedTables = await DatabaseHelper.verifyTables(db);
    print("Verified tables: $verifiedTables");
  }

  Future<void> checkTableContents(String tableName) async {
    final db = await DatabaseHelper.initDatabase();
    final data = await DatabaseHelper.fetchTableData(db, tableName);
    print("Data in '$tableName': $data");
  }

  Future<void> loadTableData(String tableName) async {
    final db = await DatabaseHelper.initDatabase();
    final data = await DatabaseHelper.fetchTableData(db, tableName);
    setState(() {
      tableData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Tables')),
      body: Column(
        children: [
          Expanded( // Shows table names first
            child: tableNames.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: tableNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tableNames[index]),
                        onTap: () {
                          loadTableData(tableNames[index]);
                        },
                      );
                    },
                  ),
          ),
          Expanded( // Displays fetched data from the selected table
            child: tableData.isEmpty
                ? const Text('Tap a table to view its contents')
                : ListView.builder(
                    itemCount: tableData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tableData[index].toString()), // Show raw data
                      );
                    },
                  ),
          ),
        ],
    ),
    );
  }
}