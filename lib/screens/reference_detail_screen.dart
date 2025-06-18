import 'package:flutter/material.dart';
import '../models/reference_item_base.dart';

class ReferenceDetailScreen extends StatelessWidget {
  final ReferenceItemBase item;
  final Widget Function(BuildContext)? buildContent;

  const ReferenceDetailScreen({
    super.key,
    required this.item,
    this.buildContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildContent != null
            ? buildContent!(context)
            : Text('No detail view implemented for ${item.runtimeType}'),
      ),
    );
  }
}
