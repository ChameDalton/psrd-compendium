// lib/screens/feat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/models/feat_reference.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class FeatListScreen extends StatelessWidget {
  const FeatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feats'),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => (context as Element).markNeedsBuild(),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getItemsByType('feat', dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('FeatListScreen error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No feats found'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final feat = FeatReference.fromMap({
                ...item,
                'database': 'book-cr.db',
                'url': item['url'] ?? '',
              });
              final subtitle = feat.prerequisites != null
                  ? '${feat.formattedTypeLine} - Prerequisites: ${feat.prerequisites} - ${feat.shortDescription}'
                  : '${feat.formattedTypeLine} - ${feat.shortDescription}';
              return ListTile(
                title: Text(feat.name),
                subtitle: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  context.push('/category/feat/${feat.sectionId}');
                },
              );
            },
          );
        },
      ),
    );
  }
}