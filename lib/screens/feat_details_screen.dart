import 'package:flutter/material.dart';
import 'package:psrd_compendium/database_helper.dart';

class FeatDetailsScreen extends StatelessWidget {
  final String featId;

  const FeatDetailsScreen({super.key, required this.featId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feat Details')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getSectionDetails(featId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No details found'));
          }
          final details = snapshot.data!;
          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final detail = details[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(detail['body'] ?? 'No content'),
              );
            },
          );
        },
      ),
    );
  }
}