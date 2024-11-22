import 'package:flutter/material.dart';

class PromptListItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const PromptListItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey),
            )
          : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle list item tap
      },
    );
  }
}
