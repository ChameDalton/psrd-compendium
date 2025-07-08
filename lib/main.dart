import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_details_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.initDatabase();
  runApp(PathfinderAthenaeumApp(dbHelper: dbHelper));
}

class PathfinderAthenaeumApp extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const PathfinderAthenaeumApp({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(dbHelper: dbHelper),
      routes: {
        '/spell_details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return SpellDetailsScreen(
            sectionId: args['sectionId']!,
            spellName: args['spellName']!,
            dbHelper: dbHelper,
          );
        },
        '/feat_details': (context) => FeatDetailsScreen(
              featId: ModalRoute.of(context)!.settings.arguments as String,
              dbHelper: dbHelper,
            ),
        '/class_details': (context) => ClassDetailsScreen(
              classId: ModalRoute.of(context)!.settings.arguments as String,
              dbHelper: dbHelper,
            ),
        '/race_details': (context) => RaceDetailsScreen(
              raceId: ModalRoute.of(context)!.settings.arguments as String,
              dbHelper: dbHelper,
            ),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const HomeScreen({super.key, required this.dbHelper});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SpellListScreen(dbHelper: widget.dbHelper),
      FeatListScreen(dbHelper: widget.dbHelper),
      ClassListScreen(dbHelper: widget.dbHelper),
      RaceListScreen(dbHelper: widget.dbHelper),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Spells',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Feats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Races',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}