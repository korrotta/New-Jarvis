import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_agent.dart';
import 'package:newjarvis/enums/id.dart';

class AiModelSelectionSection extends StatefulWidget {
  final Function(String) onAiSelected;

  const AiModelSelectionSection({
    super.key,
    required this.onAiSelected,
  });

  @override
  State<AiModelSelectionSection> createState() =>
      _AiModelSelectionSectionState();
}

class _AiModelSelectionSectionState extends State<AiModelSelectionSection> {
  final List<String> _aiIds = [
    Id.CLAUDE_3_HAIKU_20240307.value,
    Id.CLAUDE_3_SONNET_20240229.value,
    Id.GEMINI_15_FLASH_LATEST.value,
    Id.GEMINI_15_PRO_LATEST.value,
    Id.GPT_4_O.value,
    Id.GPT_4_O_MINI.value
  ];

  String _selectedAiId = Id.CLAUDE_3_HAIKU_20240307.value;

  String _formatAiId(String aiId) {
    return aiId.replaceAll('-', ' ').split(' ').map((String word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Create spinner for AI Agents
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Tooltip(
            message: "Select the AI Agent you want",
            child: DropdownButton<String>(
              value: _selectedAiId,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 14,
              ),
              underline: Container(
                height: 2,
                color: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAiId = newValue!;
                  widget.onAiSelected(newValue);
                });
              },
              items: _aiIds.map<DropdownMenuItem<String>>(
                (String value) {
                  String imageName;
                  if (value.contains('claude')) {
                    imageName = 'claude';
                  } else if (value.contains('gemini')) {
                    imageName = 'gemini';
                  } else if (value.contains('gpt')) {
                    imageName = 'gpt';
                  } else {
                    imageName = 'icon'; // Fallback image if needed
                  }
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AiAgent(
                      AiIcon: 'assets/icons/$imageName.png',
                      AiName: _formatAiId(value),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
