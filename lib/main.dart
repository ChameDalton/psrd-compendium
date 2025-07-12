// Only replace _buildMenuItem in HomeScreen
Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
  final hasSubItems = item['Type'] == null || item['Type'].isEmpty;
  if (hasSubItems) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getMenuItems(parentMenuId: item['Menu_id']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ListTile(title: Text(item['Name'] ?? 'Unknown'), subtitle: const Text('Error loading subitems'));
        }
        if (!snapshot.hasData) {
          return ListTile(title: Text(item['Name'] ?? 'Unknown'), trailing: const CircularProgressIndicator());
        }
        final subItems = snapshot.data!;
        return ExpansionTile(
          title: Text(item['Name'] ?? 'Unknown'),
          children: subItems.map((subItem) {
            return ListTile(
              title: Text(subItem['Name'] ?? 'Unknown'),
              onTap: subItem['Url'] != null
                  ? () {
                      Navigator.pushNamed(context, subItem['Url'] as String);
                    }
                  : null,
            );
          }).toList(),
        );
      },
    );
  }
  return ListTile(
    title: Text(item['Name'] ?? 'Unknown'),
    onTap: item['Url'] != null
        ? () {
            Navigator.pushNamed(context, item['Url'] as String);
          }
        : null,
  );
}