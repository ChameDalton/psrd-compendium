import 'package:flutter/material.dart';
import '../database_helper.dart';

class CreatureListScreen extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const CreatureListScreen({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Creatures')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseHelper.querySections('creature'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final creatures = snapshot.data ?? [];
          return ListView.builder(
            itemCount: creatures.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(creatures[index]['name']),
                onTap: () {
                  // Navigate to details screen with parent_id if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}