import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_model_selection_section.dart';
import 'package:newjarvis/components/bottom_switch_section.dart';
import 'package:newjarvis/components/chat_input_section.dart';
import 'package:newjarvis/models/ai_model.dart';

class BottomNavSection extends StatelessWidget {
  final String selectedModel;
  final List<AIModel> aiModels;
  final int selectedIndex;

  final List<String> filters = [
    'All',
    'AI Models',
    'Agents',
    'Social Platforms',
    'Work Scenarios',
    'Emotions'
  ];

  BottomNavSection({
    super.key,
    required this.selectedModel,
    required this.aiModels,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            // AI Model Selection
            AiModelSelectionSection(
              selectedModel: selectedModel,
              aiModels: aiModels,
              filters: filters,
            ),

            // Chat Input Section
            const ChatInputSection(),

            // Switches
            const BottomSwitchSection(),
          ],
        ),
      ),
    );
  }
}
