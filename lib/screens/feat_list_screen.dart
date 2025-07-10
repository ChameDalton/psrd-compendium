import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';
import '../services/database_helper.dart';

class FeatListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const FeatListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feats')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'feat'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading feats. Please check database.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feats = snapshot.data!;
          if (feats.isEmpty) {
            return const Center(child: Text('No feats found.'));
          }
          return ListView.builder(
            itemCount: feats.length,
            itemBuilder: (context, index) {
              final feat = feats[index];
              return ListTile(
                title: Text(feat['Name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/feat_details',
                    arguments: {
                      'id': feat['Section_id'].toString(),
                      'dbName': feat['Database'],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}