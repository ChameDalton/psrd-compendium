import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class FeatListScreen extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  FeatListScreen({super.key, DatabaseHelper? databaseHelper})
      : databaseHelper = databaseHelper ?? DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feats')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseHelper.getItemsByType('feat', dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('FeatListScreen error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final feats = snapshot.data ?? [];
          if (feats.isEmpty) {
            return const Center(child: Text('No feats found'));
          }
          return ListView.builder(
            itemCount: feats.length,
            itemBuilder: (context, index) {
              final feat = feats[index];
              return ListTile(
                title: Text(feat['name'] ?? 'Unknown Feat'),
                subtitle: Text(feat['description'] ?? 'No description'),
                onTap: () {
                  context.push('/category/feat/${feat['section_id']}');
                },
              );
            },
          );
        },
      ),
    );
  }
}