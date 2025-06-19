import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psrd_compendium/services/database_helper.dart';

class CategoryScreen extends StatelessWidget {
  final String type;

  const CategoryScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(type)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getItemsByType(type.toLowerCase(), dbName: 'book-cr.db'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No items found'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['name'] ?? 'Unknown'),
                subtitle: Text(
                  item['description']?.substring(0, 50) ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => context.go('/category/$type/${item['section_id']}'),
              );
            },
          );
        },
      ),
    );
  }
}