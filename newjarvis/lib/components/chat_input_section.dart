import 'package:flutter/material.dart';
import 'package:newjarvis/states/chat_state.dart';

import 'package:provider/provider.dart';

class ChatInputSection extends StatelessWidget {
  final String Function(String) onSend;

  const ChatInputSection({
    super.key,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ChatState>(context);

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
                controller: TextEditingController(text: chatState.chatInput)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: chatState.chatInput.length),
                  ),
                onChanged: (value) {
                  chatState.updateChatInput(value); // Update chat input state
                },
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
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
                if (chatState.chatInput.isNotEmpty) {
                  onSend(chatState.chatInput);
                  chatState.clearChatInput(); // Clear chat input after sending
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please type a message'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
