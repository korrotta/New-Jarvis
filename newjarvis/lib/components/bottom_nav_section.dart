import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_model_selection_section.dart';
import 'package:newjarvis/components/bottom_switch_section.dart';
import 'package:newjarvis/components/chat_input_section.dart';
import 'package:newjarvis/models/ai_model.dart';

class BottomNavSection extends StatefulWidget {
  final String selectedModel;
  final List<AIModel> aiModels;
  final int selectedIndex;
  final String Function(String) onSend;

  const BottomNavSection({
    super.key,
    required this.selectedModel,
    required this.aiModels,
    required this.selectedIndex,
    required this.onSend,
  });

  @override
  State<BottomNavSection> createState() => _BottomNavSectionState();
}

class _BottomNavSectionState extends State<BottomNavSection> {
  String chat = '';
  final List<String> filters = [
    'All',
    'AI Models',
    'Agents',
    'Social Platforms',
    'Work Scenarios',
    'Emotions'
  ];

  // Send chat
  String _sendChat() {
    return chat;
  }

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
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: [
          // AI Model Selection
          AiModelSelectionSection(
            selectedModel: widget.selectedModel,
            aiModels: widget.aiModels,
            filters: filters,
          ),

          // Chat Input Section
          ChatInputSection(
            onSend: widget.onSend,
          ),

          // Switches
          const BottomSwitchSection(),
        ],
      ),
    );
  }
}
