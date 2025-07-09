import 'package:flutter/material.dart';
import '../db/user_database.dart';

class BookmarkScreen extends StatefulWidget {
  final UserDatabase userDb;

  const BookmarkScreen({super.key, required this.userDb});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.userDb.getBookmarks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bookmarks = snapshot.data!;
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text-ioText(bookmark['name']),
                subtitle: Text(bookmark['url']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await widget.userDb.deleteBookmark(bookmark['_id']);
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Bookmark removed')),
                    );
                    setState(() {});
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(context, bookmark['url']);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.userDb.addBookmark(1, 'Fireball', 'pfsrd://Spells/Fireball');
          setState(() {});
        },
        child: const Icon(Icons.bookmark_add),
      ),
    );
  }
}