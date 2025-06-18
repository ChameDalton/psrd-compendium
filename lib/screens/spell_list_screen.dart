import 'package:flutter/material.dart';
import '../models/spell_reference.dart';
import '../services/mock_data_service.dart';
import '../screens/reference_detail_screen.dart';
import '../widgets/reference_list_tile.dart';

class SpellListScreen extends StatelessWidget {
  const SpellListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SpellReference> spells = MockDataService.getMockSpells();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spells'),
      ),
      body: ListView.builder(
        itemCount: spells.length,
        itemBuilder: (context, index) {
          final spell = spells[index];
          return ReferenceListTile(
            item: spell,
            subtitle: spell.schoolLine,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReferenceDetailScreen(
                    item: spell,
                    buildContent: (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${spell.level} — ${spell.classes}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          spell.shortDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
