import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_chat/ai_model_selection_section.dart';
import 'package:newjarvis/components/prompt/prompt_section.dart';
import 'package:newjarvis/components/widgets/chat_input_section.dart';

class BottomNavSection extends StatefulWidget {
  final Function(String) onSend;
  final Function(String) onAiSelected;
  final Function()? onNewConversation;

  const BottomNavSection({
    super.key,
    required this.onSend,
    required this.onAiSelected,
    this.onNewConversation,
  });

  @override
  State<BottomNavSection> createState() => _BottomNavSectionState();
}

class _BottomNavSectionState extends State<BottomNavSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
            SingleChildScrollView(
              child: Row(
                children: [
                  // Ai Switch Section
                  AiModelSelectionSection(
                    onAiSelected: widget.onAiSelected,
                  ),
                  // Prompt Section
                  const PromptSection(),
                ],
              ),
            ),
            // Chat Input Section
            ChatInputSection(
              onSend: widget.onSend,
              onNewConversation: widget.onNewConversation,
            ),
          ],
        ),
      ),
    );
  }
}
