import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class SpellDetailsScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;
  final String sectionId;
  final String spellName;

  const SpellDetailsScreen({
    super.key,
    required this.dbHelper,
    required this.sectionId,
    required this.spellName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spellName),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: dbHelper.getSpellDetails(context, sectionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!['section'] == null) {
            return const Center(child: Text('Spell not found'));
          }

          final section = snapshot.data!['section'] as Map<String, dynamic>;
          final spellDetails = snapshot.data!['spell_details'] as Map<String, dynamic>?;
          final spellEffects = snapshot.data!['spell_effects'] as List<Map<String, dynamic>>;
          final subsections = snapshot.data!['subsections'] as List<Map<String, dynamic>>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Level
                if (spellDetails != null && spellDetails['level_text'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Level: ${spellDetails['level_text']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Casting Time
                if (spellDetails != null && spellDetails['casting_time'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Casting Time: ${spellDetails['casting_time']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Components
                if (spellDetails != null && spellDetails['component_text'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Components: ${spellDetails['component_text']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Range
                if (spellDetails != null && spellDetails['range'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Range: ${spellDetails['range']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Spell Effects
                if (spellEffects.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: spellEffects.map((effect) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              effect['name'] ?? 'Effect',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              effect['description'] ?? '',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                // Duration
                if (spellDetails != null && spellDetails['duration'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Duration: ${spellDetails['duration']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Saving Throw
                if (spellDetails != null && spellDetails['saving_throw'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Saving Throw: ${spellDetails['saving_throw']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Spell Resistance
                if (spellDetails != null && spellDetails['spell_resistance'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Spell Resistance: ${spellDetails['spell_resistance']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Source
                if (section['source'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Source: ${section['source']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Summary (Description)
                if (section['description'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Summary: ${section['description']}',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Body (HTML)
                if (section['body'] != null)
                  Html(
                    data: section['body'],
                    style: {
                      'p': Style(
                        fontSize: FontSize.medium,
                        margin: Margins(bottom: Margin(8.0)),
                      ),
                      'b': Style(
                        fontWeight: FontWeight.bold,
                      ),
                    },
                  ),
                // Subsections (if any)
                if (subsections.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: subsections.map((subsection) {
                      final subSectionData = subsection['section'] as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subSectionData['name'] ?? 'Subsection',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            if (subSectionData['body'] != null)
                              Html(
                                data: subSectionData['body'],
                                style: {
                                  'p': Style(
                                    fontSize: FontSize.medium,
                                    margin: Margins(bottom: Margin(8.0)),
                                  ),
                                  'b': Style(
                                    fontWeight: FontWeight.bold,
                                  ),
                                },
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}