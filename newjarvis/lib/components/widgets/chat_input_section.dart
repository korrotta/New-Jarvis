import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newjarvis/components/prompt/promp_float_menu.dart';
import 'package:newjarvis/states/chat_state.dart';
import 'package:provider/provider.dart';

class ChatInputSection extends StatefulWidget {
  final Function(String) onSend;
  final Function()? onNewConversation;

  const ChatInputSection({
    super.key,
    required this.onSend,
    this.onNewConversation,
  });

  @override
  State<ChatInputSection> createState() => _ChatInputSectionState();
}

class _ChatInputSectionState extends State<ChatInputSection> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

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

  void _onTextChanged(BuildContext context, String value) {
    final chatState = Provider.of<ChatState>(context, listen: false);
    chatState.updateChatInput(value);
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (chatState.isPromptMenuVisible) {
        chatState.updatePromptSearchQuery(value.substring(1)); // Remove '/'
      }
    });
  }

  // Handle new conversation
  void _startNewConversation() {
    // Call the new thread callback to reset the chat
    if (widget.onNewConversation != null) {
      widget.onNewConversation!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ChatState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          if (chatState.isPromptMenuVisible) PromptMenu(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        tooltip: 'Start a new conversation',
                        color: Colors.blueAccent,
                        icon: Transform.flip(
                          flipX: true,
                          child: Icon(
                            Icons.add_comment_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        onPressed:
                            _startNewConversation, // Trigger start new conv
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          focusNode: _focusNode,
                          onSubmitted: (_) => _sendChat(context),
                          onChanged: (value) => _onTextChanged(context, value),
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Theme.of(context).colorScheme.secondary,
                          ),
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: chatState.chatInput,
                              selection: TextSelection.collapsed(
                                  offset: chatState.chatInput.length),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      tooltip: 'Send message',
                      icon: Icon(
                        Icons.send_sharp,
                        color: Theme.of(context).colorScheme.primary,
                        size: 26,
                      ),
                      onPressed: () => _sendChat(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
