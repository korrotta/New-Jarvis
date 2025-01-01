import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/models/ai_chat/conversation_item_model.dart';

class ConversationSidebar extends StatefulWidget {
  final List<ConversationItemModel> conversations;
  final Function(String) onSelectedConversation;
  final String remainingTokens;
  final String totalTokens;

  const ConversationSidebar({
    super.key,
    required this.conversations,
    required this.onSelectedConversation,
    required this.remainingTokens,
    required this.totalTokens,
  });

  @override
  State<ConversationSidebar> createState() => _ConversationSidebarState();
}

class _ConversationSidebarState extends State<ConversationSidebar> {
  bool _isSidebarVisible = false;

  String _formatDate(String timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp) * 1000,
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-Left Button to Open Sidebar
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.menu_rounded, size: 32),
            color: Theme.of(context).colorScheme.inversePrimary,
            onPressed: () {
              setState(() {
                _isSidebarVisible = true;
              });
            },
          ),
        ),
        // Sidebar
        if (_isSidebarVisible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            left: _isSidebarVisible ? 0 : -250,
            child: Container(
              width: 250,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sidebar Header
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    color: Theme.of(context).colorScheme.surface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Conversations',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _isSidebarVisible = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Conversation List
                  Expanded(
                    child: widget.conversations.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            itemCount: widget.conversations.length,
                            itemBuilder: (context, index) {
                              final conversation = widget.conversations[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  conversation.title[0].toUpperCase() +
                                      conversation.title.substring(1),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  _formatDate(
                                      conversation.createdAt.toString()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                                onTap: () {
                                  widget
                                      .onSelectedConversation(conversation.id);
                                  setState(() {
                                    _isSidebarVisible = false;
                                  });
                                },
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No conversations available.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                  ),
                  // Sidebar Footer (Remaining Tokens)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      'Remaining Tokens: ${widget.remainingTokens} / ${widget.totalTokens}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
