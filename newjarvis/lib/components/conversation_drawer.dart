import 'package:flutter/material.dart';
import 'package:newjarvis/models/conversation_item_model.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:provider/provider.dart';

class ConversationDrawer extends StatefulWidget {
  final List<ConversationItemModel> conversations;
  final Function(String) onSelectedConversation;
  final Function() onToggleDrawer;
  final String remainingTokens;
  final String totalTokens;

  const ConversationDrawer({
    super.key,
    required this.conversations,
    required this.onSelectedConversation,
    required this.onToggleDrawer,
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 70 : 250,
      child: Drawer(
        backgroundColor: _isCollapsed
            ? Colors.transparent
            : Theme.of(context).colorScheme.surface,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  if (!_isCollapsed) ...[
                    const SizedBox(width: 10),
                    Text(
                      'Conversations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isCollapsed ? Icons.menu_rounded : Icons.close,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                        widget.onToggleDrawer();
                      });
                    },
                  ),
                ],
              ),
            ),

            // List of Conversations
            if (!_isCollapsed)
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListView.builder(
                    itemCount: widget.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = widget.conversations[index];
                      return ListTile(
                        title: constraints.maxWidth > 100
                            ? Text(
                                '${conversation.title[0].toUpperCase()}${conversation.title.substring(1)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              )
                            : null,
                        subtitle: constraints.maxWidth > 100
                            ? Text(
                                _formatDate(conversation.createdAt.toString()),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              )
                            : null,
                        onTap: () {
                          widget.onSelectedConversation(conversation.id);
                        },
                      );
                    },
                  );
                }),
              ),

            // Drawer Footer (Remaining Usage Token)
            if (!_isCollapsed)
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      'Remaining Usage Token: ${widget.remainingTokens} / ${widget.totalTokens}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
