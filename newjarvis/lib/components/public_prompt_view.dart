import 'package:flutter/material.dart';
import 'package:newjarvis/components/prompt_list_item.dart';

class PublicPromptsView extends StatelessWidget {
  final List<Map<String, dynamic>> prompts;

  const PublicPromptsView({required this.prompts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categories (Chips)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8,
            children: [
              CategoryChip(text: "All", isSelected: true),
              CategoryChip(text: "Marketing", isSelected: false),
              CategoryChip(text: "Business", isSelected: false),
              CategoryChip(text: "SEO", isSelected: false),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Public Prompts List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return PromptListItem(
                title: prompt['name'] ?? 'No Title',
                subtitle: prompt['description'] ?? '',
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CategoryChip({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
