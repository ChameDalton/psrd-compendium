import 'package:flutter/material.dart';
import '../db/user_database.dart';

class BookmarkScreen extends StatelessWidget {
  final UserDatabase userDb;

  BookmarkScreen(this.userDb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userDb.getBookmarks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final bookmarks = snapshot.data!;
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text(bookmark['name']),
                subtitle: Text(bookmark['url']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await userDb.deleteBookmark(bookmark['_id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bookmark removed')),
                    );
                    (context as Element).markNeedsBuild(); // Refresh UI
                  },
                ),
                onTap: () {
                  // Navigate to content using bookmark['url']
                  Navigator.pushNamed(context, bookmark['url']);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example: Add a bookmark (replace with actual section data)
          await userDb.addBookmark(1, 'Fireball', 'pfsrd://Spells/Fireball');
          (context as Element).markNeedsBuild(); // Refresh UI
        },
        child: Icon(Icons.bookmark_add),
      ),
    );
  }
}