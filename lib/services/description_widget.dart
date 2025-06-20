import 'package:flutter_html/flutter_html.dart';
     import 'package:flutter/material.dart';

     class DescriptionWidget extends StatelessWidget {
       final String htmlContent;

       const DescriptionWidget({super.key, required this.htmlContent});

       @override
       Widget build(BuildContext context) {
         return SingleChildScrollView(
           child: Html(
             data: htmlContent,
             style: {
               'body': Style(fontSize: FontSize(16)),
               'table': Style(border: Border.all(color: Colors.grey)),
               'a': Style(color: Colors.blue),
             },
           ),
         );
       }
     }