import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final DbWrangler dbWrangler;

  const SplashScreen({required this.dbWrangler, super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('firstRun') ?? true;

    if (isFirstRun) {
      await widget.dbWrangler.initializeDatabases(context);
      await prefs.setBool('firstRun', false);
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/app_icon.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}