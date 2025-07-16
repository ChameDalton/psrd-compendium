import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class ClassListScreen extends StatelessWidget {
  final DbWrangler dbWrangler;

  const ClassListScreen({required this.dbWrangler, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbWrangler.getSections(context, 'class'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading classes'));
          }
          final classes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classItem = classes[index];
              return ListTile(
                title: Text(classItem['name']),
                onTap: () {
                  // Navigate to class details (TBD)
                },
              );
            },
          );
        },
      ),
    );
  }
}
