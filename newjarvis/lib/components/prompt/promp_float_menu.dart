import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/states/chat_state.dart';
import 'package:provider/provider.dart';

class PromptMenu extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final chatState = Provider.of<ChatState>(context);
        final searchQuery = chatState.promptSearchQuery;

        return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getPrompts(context, searchQuery, chatState),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No prompts found');
                    } else {
                        return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: snapshot.data!.map((prompt) {
                                    final promptName = prompt['title'] ?? 'Unnamed';
                                    final promptContent = prompt['content'] ?? '';
                                    return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: ActionChip(
                                            label: Text(promptName),
                                            onPressed: () {
                                                // Fill the chat input with selected prompt
                                                final chatInput = '$promptContent';
                                                chatState.updateChatInput(chatInput);
                                            },
                                        ),
                                    );
                                }).toList(),
                            ),
                        );
                    }
                },
            ),
        );
    }

    Future<List<Map<String, dynamic>>> _getPrompts(BuildContext context, String searchQuery, ChatState chatState) async {
        try {
            if (searchQuery.isEmpty) {
                return [];
            }
            final prompts = await ApiService().getPrompts(
                query: searchQuery,
                context: context,
                limit: 20,
            );
            return prompts;
        } catch (e) {
            print('Error getting prompts: $e');
            return [];
        }
    }
}

