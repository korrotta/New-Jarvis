import 'package:flutter/material.dart';
import 'package:newjarvis/components/prompt_list_item.dart';

class MyPromptsView extends StatelessWidget {
  final List<Map<String, dynamic>> prompts;

  const MyPromptsView({required this.prompts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: prompts.length,
      itemBuilder: (context, index) {
        final prompt = prompts[index];
        return PromptListItem(
          title: prompt['name'] ?? 'No Title',
          subtitle: prompt['description'] ?? '',
        );
      },
    );
  }
}
