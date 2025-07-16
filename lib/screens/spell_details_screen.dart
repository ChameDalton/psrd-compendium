import 'package:flutter/material.dart';

class SpellDetailsScreen extends StatelessWidget {
  final String spellName;
  final String url;

  const SpellDetailsScreen({required this.spellName, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(spellName)),
      body: Center(child: Text('Details for $spellName: $url')),
    );
  }
}