import 'package:flutter/material.dart';
import '../db/user_database.dart';

class BookmarkScreen extends StatelessWidget {
  final UserDatabase userDb;

  const BookmarkScreen({super.key, required this.userDb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userDb.getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading bookmarks'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bookmarks = snapshot.data!;
          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks found'));
          }
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text(bookmark['name'] ?? 'Unknown'),
                onTap: () {
                  Navigator.pushNamed(context, bookmark['url']);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await userDb.removeBookmark(bookmark['url']);
                    // ignore: invalid_use_of_protected_member
                    (context as Element).markNeedsBuild();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await userDb.addBookmark('pfsrd://Spells/Fireball', 'Fireball');
          // ignore: invalid_use_of_protected_member
          (context as Element).markNeedsBuild();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}