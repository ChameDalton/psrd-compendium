import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class DetailScreen extends StatelessWidget {
  final DbWrangler dbWrangler;
  final String name;
  final String url;

  const DetailScreen({
    required this.dbWrangler,
    required this.name,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () async {
              await dbWrangler.addBookmark(name, url);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark added')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Details for $name\nURL: $url'),
      ),
    );
  }
}