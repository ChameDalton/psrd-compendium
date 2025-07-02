import 'package:flutter/material.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';

class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getSections('class'),
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
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: Text(classData['name'] ?? 'Details')),
                        body: const Center(child: Text('Class details TBD')),
                      ),
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