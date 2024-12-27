import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_model_selection_section.dart';
import 'package:newjarvis/components/bottom_switch_section.dart';
import 'package:newjarvis/components/chat_input_section.dart';

class BottomNavSection extends StatefulWidget {
  final Function(String) onSend;
  final Function(String) onAiSelected;

  const BottomNavSection({
    super.key,
    required this.onSend,
    required this.onAiSelected,
  });

  @override
  State<BottomNavSection> createState() => _BottomNavSectionState();
}

class _BottomNavSectionState extends State<BottomNavSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Wrap(
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        children: [
          Row(
            children: [
              // Ai Switch Section
              AiModelSelectionSection(
                onAiSelected: widget.onAiSelected,
              ),
              // Prompt Section
              const PromptSection(),
            ],
          ),
          // Chat Input Section
          ChatInputSection(
            onSend: widget.onSend,
          ),
        ],
      ),
    );
  }
}
