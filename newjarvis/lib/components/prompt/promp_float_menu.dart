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
                        return _buildLoadingIndicator();
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
                                                final chatInput = '$promptContent';
                                                chatState.updateChatInput(chatInput);
                                            },
                                            shape: StadiumBorder(side: BorderSide.none), // This removes the border
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

    Widget _buildLoadingIndicator() {
        return Center(
            child: SizedBox(
                height: 20.0,
                child: WavingDots(),
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

class WavingDots extends StatefulWidget {
    @override
    _WavingDotsState createState() => _WavingDotsState();
}

class _WavingDotsState extends State<WavingDots> with TickerProviderStateMixin {
    late AnimationController _controller;
    late List<Animation<double>> _animations;

    @override
    void initState() {
        super.initState();
        _controller = AnimationController(
            duration: const Duration(milliseconds: 1200),
            vsync: this,
        )..repeat();

        _animations = List.generate(3, (index) {
            return Tween<double>(begin: 0, end: -5).animate(
                CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                        index * 0.2, (index * 0.2) + 0.6, curve: Curves.easeInOut,
                    ),
                ),
            );
        });
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
                return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                        return Transform.translate(
                            offset: Offset(0, _animations[index].value),
                            child: _dot(),
                        );
                    },
                );
            }),
        );
    }

    Widget _dot() {
        return Container(
            width: 5.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
            ),
        );
    }
}

