import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/models/assistant/assistant_thread_model.dart';

class ThreadDrawer extends StatefulWidget {
  final List<AssistantThreadModel> threads;
  final Function(String) onSelectedThread;

  const ThreadDrawer({
    super.key,
    required this.threads,
    required this.onSelectedThread,
  });

  @override
  State<ThreadDrawer> createState() => _ThreadDrawerState();
}

class _ThreadDrawerState extends State<ThreadDrawer> {
  bool _isLoading = true; // Initially loading

  @override
  void initState() {
    super.initState();
    _initializeConversations();
  }

  Future<void> _initializeConversations() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }

  String _formatDate(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(dateTime);
  }

  Map<String, List<AssistantThreadModel>> _groupThreads() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));
    final monthAgo = today.subtract(const Duration(days: 30));

    final Map<String, List<AssistantThreadModel>> groupedConversations = {
      'Today': [],
      'Yesterday': [],
      'Previous 7 Days': [],
      'Previous 30 Days': [],
      'Older': [],
    };

    for (var thread in widget.threads) {
      final createdAt = DateTime.parse(thread.createdAt.toString());

      if (createdAt.isAfter(today)) {
        groupedConversations['Today']?.add(thread);
      } else if (createdAt.isAfter(yesterday)) {
        groupedConversations['Yesterday']?.add(thread);
      } else if (createdAt.isAfter(weekAgo)) {
        groupedConversations['Previous 7 Days']?.add(thread);
      } else if (createdAt.isAfter(monthAgo)) {
        groupedConversations['Previous 30 Days']?.add(thread);
      } else {
        groupedConversations['Older']?.add(thread);
      }
    }

    return groupedConversations;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }

    final groupedThreads = _groupThreads();
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
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
                  'Threads',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          // Conversation List
          Expanded(
            child: widget.threads.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: groupedThreads.entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map((entry) {
                      final sectionTitle = entry.key;
                      final threads = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Text(
                              sectionTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          // Conversation Items
                          ...threads.map((thread) {
                            return ListTile(
                              title: Text(
                                thread.threadName[0].toUpperCase() +
                                    thread.threadName.substring(1),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                _formatDate(thread.createdAt.toString()),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              onTap: () {
                                widget.onSelectedThread(thread.openAiThreadId);
                                Navigator.of(context).pop();
                              },
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  )
                : const Center(
                    child: Text(
                      'No threads available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
