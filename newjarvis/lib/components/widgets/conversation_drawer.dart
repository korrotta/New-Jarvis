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

  Map<String, List<ConversationItemModel>> _groupConversations() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));
    final monthAgo = today.subtract(const Duration(days: 30));

    final Map<String, List<ConversationItemModel>> groupedConversations = {
      'Today': [],
      'Yesterday': [],
      'Previous 7 Days': [],
      'Previous 30 Days': [],
      'Older': [],
    };

    for (var conversation in widget.conversations) {
      final createdAt = DateTime.fromMillisecondsSinceEpoch(
        int.parse(conversation.createdAt.toString()) * 1000,
      );

      if (createdAt.isAfter(today)) {
        groupedConversations['Today']?.add(conversation);
      } else if (createdAt.isAfter(yesterday)) {
        groupedConversations['Yesterday']?.add(conversation);
      } else if (createdAt.isAfter(weekAgo)) {
        groupedConversations['Previous 7 Days']?.add(conversation);
      } else if (createdAt.isAfter(monthAgo)) {
        groupedConversations['Previous 30 Days']?.add(conversation);
      } else {
        groupedConversations['Older']?.add(conversation);
      }
    }

    return groupedConversations;
  }

  @override
  Widget build(BuildContext context) {
    final groupedConversations = _groupConversations();
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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sidebar Header
                  Container(
                    padding: const EdgeInsets.all(12.0),
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
                        ? ListView(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            children: groupedConversations.entries
                                .where((entry) => entry.value.isNotEmpty)
                                .map((entry) {
                              final sectionTitle = entry.key;
                              final conversations = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section Header
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    child: Text(
                                      sectionTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  // Conversation Items
                                  ...conversations.map((conversation) {
                                    return ListTile(
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
                                        widget.onSelectedConversation(
                                            conversation.id);
                                        setState(() {
                                          _isSidebarVisible = false;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
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
