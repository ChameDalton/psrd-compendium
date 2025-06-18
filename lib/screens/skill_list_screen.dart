import 'package:flutter/material.dart';
import '../models/skill_reference.dart';
import '../services/mock_data_service.dart';
import '../screens/reference_detail_screen.dart';
import '../widgets/reference_list_tile.dart';

class SkillListScreen extends StatelessWidget {
  const SkillListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SkillReference> skills = MockDataService.getMockSkills();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
      ),
      body: ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          return ReferenceListTile(
            item: skill,
            subtitle: '${skill.attribute} ${skill.qualities}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReferenceDetailScreen(
                    item: skill,
                    buildContent: (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.attribute,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(skill.description),
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
