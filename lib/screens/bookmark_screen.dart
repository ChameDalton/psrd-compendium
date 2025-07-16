import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class BookmarkScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const BookmarkScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading bookmarks'));
          }
          final bookmarks = snapshot.data ?? [];
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text(bookmark['name']),
                subtitle: Text(bookmark['url']),
              );
            },
          );
        },
      ),
    );
  }
}
