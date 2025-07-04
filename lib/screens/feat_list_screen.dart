import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_details_screen.dart';

class FeatListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const FeatListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feats')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSections(context, 'feat'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No feats found'));
          }
          final feats = snapshot.data!;
          return ListView.builder(
            itemCount: feats.length,
            itemBuilder: (context, index) {
              final feat = feats[index];
              return ListTile(
                title: Text(feat['name'] ?? 'Unknown'),
                subtitle: Text(feat['source'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeatDetailsScreen(
                        featId: feat['section_id'].toString(),
                        dbHelper: dbHelper,
                      ),
                    ),
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