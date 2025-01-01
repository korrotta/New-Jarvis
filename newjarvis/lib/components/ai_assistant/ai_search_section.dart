import 'package:flutter/material.dart';

class AiSearchSection extends StatelessWidget {
  const AiSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.search_outlined,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 50,
          ),
        ),
        title: const Text(
          'AI Search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: const Text(
          'Smarter and save your time',
        ),
        onTap: () {},
      ),
    );
  }
}
