import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';

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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feats = snapshot.data!;
          return ListView.builder(
            itemCount: feats.length,
            itemBuilder: (context, index) {
              final feat = feats[index];
              return ListTile(
                title: Text(feat['name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/feat_details',
                    arguments: {'id': feat['_id'].toString(), 'dbName': 'book-cr.db'},
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