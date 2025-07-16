import 'package:flutter/material.dart';

class ClassDetailsScreen extends StatelessWidget {
  final String className;
  final String url;

  const ClassDetailsScreen({required this.className, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(className)),
      body: Center(child: Text('Details for $className: $url')),
    );
  }
}