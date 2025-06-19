import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Added import
import 'package:psrd_compendium/services/database_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final db = await DatabaseHelper().getDatabase('book-cr.db');
    final results = await db.query(
      'section_id',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      columns: ['section_id', 'name', 'description', 'body', 'source', 'type'],
    );
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: _search,
              decoration: const InputDecoration(
                labelText: 'Search Pathfinder Content',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                return ListTile(
                  title: Text(item['name']?.toString() ?? 'Unknown'),
                  subtitle: Text(
                    item['description']?.toString().substring(0, 50) ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    final type = item['type']?.toString();
                    final sectionId = item['section_id']?.toString();
                    if (type != null && sectionId != null) {
                      context.go('/category/$type/$sectionId');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}