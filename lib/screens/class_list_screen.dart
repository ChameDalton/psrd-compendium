import 'package:flutter/material.dart';
import '../db/db_wrangler.dart';
import '../services/database_helper.dart';

class ClassListScreen extends StatelessWidget {
  final DbWrangler dbHelper;

  const ClassListScreen({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getSections('index.db', 'class'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading classes. Please check database.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final classes = snapshot.data!;
          if (classes.isEmpty) {
            return const Center(child: Text('No classes found.'));
          }
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classData = classes[index];
              return ListTile(
                title: Text(classData['Name']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/class_details',
                    arguments: {
                      'id': classData['Section_id'].toString(),
                      'dbName': classData['Database'],
                    },
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