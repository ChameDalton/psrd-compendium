import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';

class ClassListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const ClassListScreen({super.key, this.dbHelper});

  @override
  Widget build(BuildContext context) {
    final effectiveDbHelper = dbHelper ?? DatabaseHelper.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: effectiveDbHelper.getSections('class'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No classes found'));
          }
          final classes = snapshot.data!;
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classData = classes[index];
              return ListTile(
                title: Text(classData['name'] ?? 'Unknown'),
                subtitle: Text(classData['source'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassDetailsScreen(classId: classData['section_id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}