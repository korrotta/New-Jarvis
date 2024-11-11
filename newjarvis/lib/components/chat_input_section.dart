import 'package:flutter/material.dart';

class ChatInputSection extends StatefulWidget {
  final String Function(String) onSend;

  const ChatInputSection({
    super.key,
    required this.onSend,
  });

  @override
  State<ChatInputSection> createState() => _ChatInputSectionState();
}

class _ChatInputSectionState extends State<ChatInputSection> {
  // Text controller for the chat input
  final TextEditingController _chatController = TextEditingController();

  // Send chat
  void _sendChat(BuildContext context) {
    final chat = _chatController.text.trim();
    if (chat.isNotEmpty) {
      widget.onSend(chat);
      _chatController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please type a message'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                controller: _chatController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                  // Transparent border
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_sharp,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                _sendChat(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
