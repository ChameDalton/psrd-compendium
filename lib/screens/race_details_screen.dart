import 'package:flutter/material.dart';

class RaceDetailsScreen extends StatelessWidget {
  final String raceName;
  final String url;

  const RaceDetailsScreen({required this.raceName, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(raceName)),
      body: Center(child: Text('Details for $raceName: $url')),
    );
  }
}