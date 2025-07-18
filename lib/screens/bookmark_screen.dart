import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const BookmarkScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbWrangler.getBookmarks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No bookmarks found'));
        }

        final bookmarks = snapshot.data!;
        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index];
            return ListTile(
              title: Text(bookmark['name'] ?? 'Unknown'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {'name': bookmark['name'], 'url': bookmark['url']},
                );
              },
            );
          },
        );
      },
    );
  }
}