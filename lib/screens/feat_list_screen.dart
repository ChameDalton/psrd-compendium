// lib/screens/feat_list_screen.dart
import 'package:flutter/material.dart';
import '../models/feat_reference.dart';
import '../services/feat_service.dart';
import '../screens/reference_detail_screen.dart';
import '../widgets/reference_list_tile.dart';

class FeatListScreen extends StatefulWidget {
  const FeatListScreen({super.key});

  @override
  State<FeatListScreen> createState() => _FeatListScreenState();
}

class _FeatListScreenState extends State<FeatListScreen> {
  late Future<List<FeatReference>> futureFeats;

  @override
  void initState() {
    super.initState();
    futureFeats = FeatService.loadCoreFeats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feats')),
      body: FutureBuilder<List<FeatReference>>(
        future: futureFeats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading feats: ${snapshot.error}'));
          } else {
            final feats = snapshot.data ?? [];
            return ListView.builder(
              itemCount: feats.length,
              itemBuilder: (context, index) {
                final feat = feats[index];
                return ReferenceListTile(
                  item: feat,
                  subtitle: feat.formattedTypeLine, // ✅ Displays feat type & description properly
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReferenceDetailScreen(
                          item: feat,
                          buildContent: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(feat.formattedTypeLine, style: Theme.of(context).textTheme.titleMedium), // ✅ Updated to formattedTypeLine
                              const SizedBox(height: 12),
                              if (feat.prerequisites != null)
                                Text('Prerequisite: ${feat.prerequisites!}', style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 16),
                              Text(feat.description),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
