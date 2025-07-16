import 'package:flutter/material.dart';

class CreatureDetailsScreen extends StatelessWidget {
  final String creatureName;
  final String url;

  const CreatureDetailsScreen({required this.creatureName, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(creatureName)),
      body: Center(child: Text('Details for $creatureName: $url')),
    );
  }
}