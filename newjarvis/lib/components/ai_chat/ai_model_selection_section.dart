import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_assistant/ai_agent.dart';
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
    return Container(
      height: 40, // Điều chỉnh chiều cao
      padding: const EdgeInsets.symmetric(horizontal: 8), // Giảm padding
      decoration: BoxDecoration(
        color: const Color.fromARGB(150, 114, 189, 255),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(152, 114, 135, 255), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAiId,
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 12),
          borderRadius: BorderRadius.circular(20),
          dropdownColor: Colors.blue.shade100,
          onChanged: (String? newValue) {
            setState(() {
              _selectedAiId = newValue!;
              widget.onAiSelected(newValue);
            });
          },
          items: _aiIds.map<DropdownMenuItem<String>>((String value) {
            String imageName;
            if (value.contains('claude')) {
              imageName = 'claude';
            } else if (value.contains('gemini')) {
              imageName = 'gemini';
            } else if (value.contains('gpt')) {
              imageName = 'gpt';
            } else {
              imageName = 'icon';
            }
            return DropdownMenuItem<String>(
              value: value,
              child: AiAgent(
                AiIcon: 'assets/icons/$imageName.png',
                AiName: _formatAiId(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
