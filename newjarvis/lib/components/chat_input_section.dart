import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newjarvis/states/chat_state.dart';
import 'package:provider/provider.dart';

class ChatInputSection extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputSection({
    super.key,
    required this.onSend,
  });

  @override
  State<ChatInputSection> createState() => _ChatInputSectionState();
}

class _ChatInputSectionState extends State<ChatInputSection> {
  final FocusNode _focusNode = FocusNode();

  // Send chat
  void _sendChat(BuildContext context) {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final chat = chatState.chatInput.trim();
    if (chat.isNotEmpty) {
      widget.onSend(chat);
      chatState.updateChatInput(''); // Clear the chat input in state
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
    final chatState = Provider.of<ChatState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (event) {
            final pressedKey = event.logicalKey;
            // Break line on Shift + Enter or Alt + Enter or Ctrl + Enter
            if (pressedKey == LogicalKeyboardKey.enter &&
                (pressedKey == LogicalKeyboardKey.shift ||
                    pressedKey == LogicalKeyboardKey.control ||
                    pressedKey == LogicalKeyboardKey.alt)) {
              // Add a newline if Shift/Alt/Ctrl + Enter is pressed
              chatState.updateChatInput(chatState.chatInput + '\n');
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  onSubmitted: (_) => _sendChat(context),
                  onChanged:
                      chatState.updateChatInput, // Update chat input in state
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
                  // Use the value from ChatState
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: chatState.chatInput,
                      selection: TextSelection.collapsed(
                          offset: chatState.chatInput.length),
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
      ),
    );
  }
}
