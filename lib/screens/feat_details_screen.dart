import 'package:flutter/material.dart';

class FeatDetailsScreen extends StatelessWidget {
  final String featName;
  final String url;

  const FeatDetailsScreen({required this.featName, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(featName)),
      body: Center(child: Text('Details for $featName: $url')),
    );
  }
}