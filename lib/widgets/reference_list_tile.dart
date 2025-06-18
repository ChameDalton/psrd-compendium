// lib/widgets/reference_list_tile.dart
import 'package:flutter/material.dart';
import '../models/reference_item_base.dart';

class ReferenceListTile extends StatelessWidget {
  final ReferenceItemBase item;
  final String? subtitle;
  final VoidCallback? onTap;

  const ReferenceListTile({
    super.key,
    required this.item,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
