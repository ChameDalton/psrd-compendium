import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class FeatListScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const FeatListScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feats')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getSections(context, 'feat'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading feats'));
          }
          final feats = snapshot.data ?? [];
          return ListView.builder(
            itemCount: feats.length,
            itemBuilder: (context, index) {
              final feat = feats[index];
              return ListTile(
                title: Text(feat['name']),
                onTap: () {
                  // Navigate to feat details (TBD)
                },
              );
            },
          );
        },
      ),
    );
  }
}
