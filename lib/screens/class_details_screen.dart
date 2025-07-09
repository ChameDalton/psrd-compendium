import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../db/db_wrangler.dart';
import '../services/database_helper.dart';

class ClassDetailsScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const ClassDetailsScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final classId = args['id'] as String;
    final dbName = args['dbName'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Class Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DatabaseHelper().getSectionWithSubsections(dbName, classId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final section = data['section'] as Map<String, dynamic>;
          final subsections = data['subsections'] as List<dynamic>;

          return ListView(
            children: [
              Html(
                data: section['body'] ?? '',
                style: {
                  'body': Style(fontSize: FontSize(16.0)),
                },
              ),
              ...subsections.map((subData) => ExpansionTile(
                    title: Text(subData['name']),
                    children: [
                      Html(
                        data: subData['body'] ?? '',
                        style: {
                          'body': Style(fontSize: FontSize(16.0)),
                        },
                      ),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}