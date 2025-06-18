import 'package:flutter/material.dart';
import '../models/creature_reference.dart';
import '../services/mock_data_service.dart';
import '../widgets/reference_list_tile.dart';
import './reference_detail_screen.dart';

class CreatureListScreen extends StatelessWidget {
  const CreatureListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CreatureReference> creatures = MockDataService.getMockCreatures();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creatures'),
      ),
      body: ListView.builder(
        itemCount: creatures.length,
        itemBuilder: (context, index) {
          final creature = creatures[index];
          return ReferenceListTile(
            item: creature,
            subtitle: '${creature.size}, ${creature.alignment} — ${creature.typeLine}',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ReferenceDetailScreen(
        item: creature,
        buildContent: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${creature.size} — ${creature.alignment}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              creature.typeLine,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'CR ${creature.challengeRating}, XP ${creature.experience}',
              style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
}
          );
        },
      ),
    );
  }
}
