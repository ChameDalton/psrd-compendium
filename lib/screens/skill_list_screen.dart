import 'package:flutter/material.dart';
   import 'package:go_router/go_router.dart';
   import 'package:pathfinder_athenaeum/models/skill_reference.dart';
   import 'package:pathfinder_athenaeum/services/database_helper.dart';

   class SkillListScreen extends StatelessWidget {
     const SkillListScreen({super.key});

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: const Text('Skills'),
           automaticallyImplyLeading: true,
         ),
         body: FutureBuilder<List<Map<String, dynamic>>>(
           future: DatabaseHelper().getItemsByType('skill', dbName: 'book-cr.db'),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return const Center(child: CircularProgressIndicator());
             }
             if (snapshot.hasError) {
               return Center(child: Text('Error: ${snapshot.error}'));
             }
             final items = snapshot.data ?? [];
             if (items.isEmpty) {
               return const Center(child: Text('No skills found'));
             }
             return ListView.builder(
               itemCount: items.length,
               itemBuilder: (context, index) {
                 final item = items[index];
                 final skill = SkillReference.fromMap(item);
                 final description = skill.description;
                 final preview = description.length > 50 ? description.substring(0, 50) : description;
                 return ListTile(
                   title: Text(skill.name),
                   subtitle: Text(
                     preview,
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                   onTap: () {
                     context.push('/category/skill/${skill.id}');
                   },
                 );
               },
             );
           },
         ),
       );
     }
   }