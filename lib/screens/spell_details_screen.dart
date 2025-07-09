import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../db/db_wrangler.dart';
import '../services/database_helper.dart';

class SpellDetailsScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const SpellDetailsScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final sectionId = args['id'] as String;
    final dbName = args['dbName'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Spell Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DatabaseHelper().getSpellDetails(dbName, sectionId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final spell = snapshot.data!;
          return ListView(
            children: [
              Html(
                data: spell['description'] ?? '',
                style: {
                  'p': Style(
                    fontSize: FontSize.medium,
                    margin: Margins.all(8.0),
                  ),
                  'b': Style(fontWeight: FontWeight.bold),
                },
              ),
              if (spell['full_text'] != null)
                Html(
                  data: spell['full_text'],
                  style: {
                    'p': Style(
                      fontSize: FontSize.medium,
                      margin: Margins.all(8.0),
                    ),
                    'b': Style(fontWeight: FontWeight.bold),
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}