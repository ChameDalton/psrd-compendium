import 'package:flutter/material.dart';
import '../db/user_database.dart';

class BookmarkScreen extends StatefulWidget {
  final UserDatabase userDb;

  const BookmarkScreen({Key? key, required this.userDb}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBar(title: Text('Bookmarks')),
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
                title: Text(bookmark['name']),
                subtitle: Text(bookmark['url']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await widget.userDb.deleteBookmark(bookmark['_id']);
                    ScaffoldMessenger.of(context).showSnackBar(
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