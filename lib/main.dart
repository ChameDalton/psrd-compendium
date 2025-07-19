import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/splash_screen.dart';
import 'package:pathfinder_athenaeum/screens/main_screen.dart';
import 'package:pathfinder_athenaeum/screens/detail_screen.dart';

void main() {
  runApp(MyApp(dbWrangler: DbWrangler()));
}

class MyApp extends StatelessWidget {
  final DbWrangler dbWrangler;

  const MyApp({required this.dbWrangler, super.key});

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(dbWrangler: dbWrangler),
        );
      case '/main':
        return MaterialPageRoute(
          builder: (_) => MainScreen(dbWrangler: dbWrangler),
        );
      case '/details':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => DetailScreen(
              dbWrangler: dbWrangler,
              name: args['name'] ?? 'Unknown',
              url: args['url'] ?? '',
            ),
          );
        }
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      title: 'Pathfinder Athenaeum',
      theme: const ThemeData(
        primarySwatch: Colors.blue,
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      initialRoute: '/splash',
      onGenerateRoute: generateRoute,
    );
  }
}