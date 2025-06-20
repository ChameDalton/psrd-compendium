import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class CategoryScreen extends StatelessWidget {
  final String type;

  const CategoryScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Adjust type to match database (e.g., 'spells' -> 'spell')
    final dbType = type.endsWith('s') ? type.substring(0, type.length - 1) : type;
    // ignore: avoid_print
    print('Loading category: $dbType');

    return Scaffold(
      appBar: AppBar(
        title: Text(type),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getItemsByType(dbType, dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('CategoryScreen error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            // ignore: avoid_print
            print('No items found for type: $dbType');
            return const Center(child: Text('No items found'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final description = item['description']?.toString() ?? '';
              final preview = description.length > 50 ? description.substring(0, 50) : description;
              return ListTile(
                title: Text(item['name']?.toString() ?? 'Unknown'),
                subtitle: Text(
                  preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  final sectionId = item['section_id']?.toString();
                  if (sectionId != null) {
                    context.push('/category/$dbType/$sectionId');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}