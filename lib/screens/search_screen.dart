import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

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
    // ignore: avoid_print
    print('Searching sections for query: $query');
    final results = await db.rawQuery(
      '''
      SELECT s.section_id, s.name, s.description, s.body, s.source, s.type,
             sd.school, sd.level_text, sa.attribute
      FROM sections s
      LEFT JOIN spell_details sd ON s.section_id = sd.section_id
      LEFT JOIN skill_attributes sa ON s.section_id = sa.section_id
      WHERE s.name LIKE ?
      ''',
      ['%$query%'],
    );
    // ignore: avoid_print
    print('Search results: ${results.length} items');
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: _search,
              decoration: const InputDecoration(
                labelText: 'Search Pathfinder Content',
                hintText: 'Enter spell, skill, or feat name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty && _controller.text.isNotEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      final description = item['description']?.toString() ?? '';
                      final preview = description.length > 50 ? description.substring(0, 50) : description;
                      String subtitle = 'Source: ${item['source'] ?? ''} - $preview';
                      final type = item['type']?.toString();
                      if (type == 'spell' && item['school'] != null) {
                        subtitle = '${item['school']} (${item['level_text'] ?? ''}) - $subtitle';
                      } else if (type == 'skill' && item['attribute'] != null) {
                        subtitle = 'Attribute: ${item['attribute']} - $subtitle';
                      }
                      return ListTile(
                        title: Text(item['name']?.toString() ?? 'Unknown'),
                        subtitle: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          final sectionId = item['section_id']?.toString();
                          if (type != null && sectionId != null) {
                            final routeType = type == 'monster' ? 'creature' : type;
                            context.push('/category/$routeType/$sectionId');
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