import 'package:flutter/material.dart';
import 'package:newjarvis/models/conversation_item_model.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:provider/provider.dart';

class ConversationDrawer extends StatefulWidget {
  final List<ConversationItemModel> conversations;
  final Function(String) onSelectedConversation;
  final String remainingTokens;
  final String totalTokens;

  const ConversationDrawer({
    super.key,
    required this.conversations,
    required this.onSelectedConversation,
    required this.remainingTokens,
    required this.totalTokens,
  });

  @override
  State<ConversationDrawer> createState() => _ConversationDrawerState();
}

class _ConversationDrawerState extends State<ConversationDrawer> {
  bool _isCollapsed = true;

  String _formatDate(String timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp) * 1000,
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (_isCollapsed) {
      // Collapsed State: Only the Icon Button
      return Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.menu_rounded,
            size: 32,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          onPressed: () {
            setState(() {
              _isCollapsed = !_isCollapsed;
            });
          },
        ),
      );
    } else {
      // Expanded State: Full Drawer
      return SizedBox(
        width: 250,
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drawer Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Conversations',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCollapsed = !_isCollapsed;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // List of Conversations
              Expanded(
                child: ListView.builder(
                  itemCount: widget.conversations.length,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemBuilder: (context, index) {
                    final conversation = widget.conversations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: const Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        conversation.title[0].toUpperCase() +
                            conversation.title.substring(1),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(conversation.createdAt.toString()),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                      onTap: () {
                        widget.onSelectedConversation(conversation.id);
                      },
                    );
                  },
                ),
              ),

              // Drawer Footer (Remaining Tokens)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Remaining Tokens: ${widget.remainingTokens} / ${widget.totalTokens}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
