import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.getDatabase('book-cr.db');
    final results = await db.rawQuery(
      'SELECT section_id, name, description, type FROM sections WHERE name LIKE ? OR description LIKE ?',
      ['%$query%', '%$query%'],
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search feats, spells, etc.',
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                return ListTile(
                  title: Text(item['name'] ?? 'Unknown'),
                  subtitle: Text('${item['type']} - ${item['description']?.substring(0, 50) ?? ''}...'),
                  onTap: () => context.push('/category/${item['type']}/${item['section_id']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}