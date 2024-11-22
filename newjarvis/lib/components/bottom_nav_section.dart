import 'package:flutter/material.dart';
import 'package:newjarvis/components/chat_input_section.dart';

class BottomNavSection extends StatefulWidget {
  final Function(String) onSend;

  const BottomNavSection({
    super.key,
    required this.onSend,
  });

  @override
  State<BottomNavSection> createState() => _BottomNavSectionState();
}

class _BottomNavSectionState extends State<BottomNavSection> {
  String chat = '';

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
          // Chat Input Section
          ChatInputSection(
            onSend: widget.onSend,
          ),
        ],
      ),
    );
  }
}
