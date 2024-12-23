import 'package:flutter/material.dart';
import 'package:newjarvis/components/bottom_nav_section.dart';
import 'package:newjarvis/components/chat_bubble.dart';
import 'package:newjarvis/components/chat_participant.dart';
import 'package:newjarvis/components/conversation_drawer.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/enums/id.dart';
import 'package:newjarvis/enums/model.dart';
import 'package:newjarvis/models/ai_chat_model.dart';
import 'package:newjarvis/models/assistant_model.dart';
import 'package:newjarvis/models/conversation_history_item_model.dart';
import 'package:newjarvis/models/conversation_item_model.dart';
import 'package:newjarvis/models/token_usage_model.dart';
import 'package:newjarvis/providers/auth_provider.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ApiService apiService = ApiService();

  // State variables
  List<ConversationItemModel> _conversations = [];
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Future<List<ConversationHistoryItemModel>>? _conversationHistoryFuture;
  int selectedIndex = 0;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  bool isDrawerVisible = false;
  double dragOffset = 200.0;
  final ScrollController _scrollController = ScrollController();
  String remainingUsage = '0';
  String totalUsage = '0';

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    apiService.signOut();
    super.dispose();
  }

  Future<void> _initializePage() async {
    await _checkLoginStatus();
    await _fetchAllConversations();
    _conversationHistoryFuture = _getAllConversationHistory(_conversations);
    await _fetchRemainingUsage();
    await _fetchTotalTokens();
    await _scrollToBottom();
  }

  Future<void> _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isSidebarVisible = false;
    });

    switch (index) {
      case 0:
        _navigatorKey.currentState?.pushReplacementNamed('/chat');
        break;
      case 1:
        _navigatorKey.currentState?.pushReplacementNamed('/email');
        break;
      case 2:
        _navigatorKey.currentState?.pushReplacementNamed('/search');
        break;
      case 3:
        _navigatorKey.currentState?.pushReplacementNamed('/write');
        break;
      case 4:
        _navigatorKey.currentState?.pushReplacementNamed('/translate');
        break;
      case 5:
        _navigatorKey.currentState?.pushReplacementNamed('/art');
        break;
      default:
        _navigatorKey.currentState?.pushReplacementNamed('/chat');
        break;
    }
  }

  Future<String> _handleSend(BuildContext context, String chat) async {
    if (chat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a message',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return chat;
    }

    // Create placeholders for the conversation
    final tempConversation = ConversationHistoryItemModel(
      query: chat,
      answer: '', // Placeholder for AI's response
      files: [],
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    // Add placeholder to the conversation history
    setState(() {
      _conversationHistoryFuture = _conversationHistoryFuture!
          .then((history) => [...history, tempConversation]);
    });

    try {
      // Call API to send the message and receive a response
      final response = await apiService.sendMessage(
        context: context,
        aiChat: AiChatModel(
          assistant: AssistantModel(
            id: Id.GPT_4_O.value,
            model: Model.dify.name,
          ),
          content: chat,
          files: null,
          metadata: null,
        ),
      );

      // Update the last message with AI's response
      setState(() {
        _conversationHistoryFuture =
            _conversationHistoryFuture!.then((history) {
          // Replace the placeholder with the final response
          final updatedHistory =
              List<ConversationHistoryItemModel>.from(history);
          updatedHistory.last = ConversationHistoryItemModel(
            query: chat,
            answer: response.message ??
                '', // Use actual AI response or empty string if null
            files: [],
            createdAt: tempConversation.createdAt,
          );
          _scrollToBottom(); // Scroll to bottom after receiving the response
          return updatedHistory;
        });
      });
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending message: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    _scrollToBottom(); // Scroll to bottom after receiving the response
    return chat;
  }

  // Fetch remaining usage
  Future<void> _fetchRemainingUsage() async {
    try {
      final TokenUsageModel tokenUsage = await apiService.getTokenUsage();
      setState(() {
        remainingUsage = tokenUsage.remainingTokens;
      });
    } catch (e) {
      print('Error fetching remaining usage: $e');
    }
  }

  // Fetch total tokens
  Future<void> _fetchTotalTokens() async {
    try {
      final TokenUsageModel tokenUsage = await apiService.getTokenUsage();
      setState(() {
        totalUsage = tokenUsage.totalTokens;
      });
    } catch (e) {
      print('Error fetching total tokens: $e');
    }
  }

  // Check login status
  Future<bool> _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.currentUser != null;
  }

  // Fetch all conversations
  Future<void> _fetchAllConversations() async {
    final assistant = AssistantModel(
      id: Id.GPT_4_O.value,
      model: Model.dify.name,
    );

    try {
      final List<ConversationItemModel> conversations =
          await apiService.getConversations(
        context: context,
        cursor: null,
        limit: 15,
        assistant: assistant,
      );
      setState(() {
        _conversations = conversations;
      });
    } catch (e) {
      print('Error fetching conversation history: $e');
    }
  }

  // Get all conversations history
  Future<List<ConversationHistoryItemModel>> _getAllConversationHistory(
      List<ConversationItemModel> conversations) async {
    List<ConversationHistoryItemModel> history = [];
    conversations = conversations.reversed.toList();
    for (var conversation in conversations) {
      final item = await _getConversationHistory(conversation.id);
      history.add(item);
    }
    _scrollToBottom();
    return history;
  }

  // Get latest conversation history
  Future<ConversationHistoryItemModel> _getConversationHistory(
      String conversationId) async {
    final assistant = AssistantModel(
      id: Id.GPT_4_O.value,
      model: Model.dify.name,
    );

    try {
      final history = await apiService.getConversationHistory(
        context: context,
        conversationId: conversationId,
        cursor: null,
        limit: 100,
        assistant: assistant,
      );
      _scrollToBottom();
      return history;
    } catch (e) {
      print('Error fetching conversation history: $e');
    }

    return ConversationHistoryItemModel(
      query: '',
      answer: '',
      files: [],
      createdAt: 0,
    );
  }

  void _handleConversationSelect(String id) {
    print('Selected conversation ID: $id');
    // Get from the first match and the rest of the list
    final List<ConversationItemModel> matchingAndRemaining = _conversations
        .where((conversation) => conversation.id == id)
        .followedBy(
          _conversations.where((conversation) => conversation.id != id),
        )
        .toList();

    setState(() {
      _conversationHistoryFuture =
          _getAllConversationHistory(matchingAndRemaining);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(top: 20),
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the layout adjusts for the keyboard
        body: authProvider.currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  AnimatedContainer(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(
                      left: isDrawerVisible ? 250 : 0,
                      right: isSidebarVisible ? (isExpanded ? 180 : 98) : 0,
                    ),
                    width: double.infinity,
                    child: _buildChatList(context),
                  ),

                  // Conversation Drawer
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: ConversationDrawer(
                      conversations: _conversations,
                      onSelectedConversation: _handleConversationSelect,
                      remainingTokens: remainingUsage,
                      totalTokens: totalUsage,
                    ),
                  ),

                  // Sidebar
                  if (isSidebarVisible)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: SideBar(
                        isExpanded: isExpanded,
                        selectedIndex: selectedIndex,
                        onItemSelected: _onItemTapped,
                        onExpandToggle: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        onClose: () {
                          setState(() {
                            isSidebarVisible = false;
                          });
                        },
                      ),
                    ),

                  // Nửa hình tròn khi sidebar bị ẩn (Floating Button)
                  if (!isSidebarVisible)
                    FloatingButton(
                      dragOffset: dragOffset,
                      onDragUpdate: (delta) {
                        setState(
                          () {
                            dragOffset += delta;
                            if (dragOffset < 0) dragOffset = 0;
                            if (dragOffset >
                                MediaQuery.of(context).size.height - 100) {
                              dragOffset =
                                  MediaQuery.of(context).size.height - 100;
                            }
                          },
                        );
                      },
                      onTap: () {
                        setState(
                          () {
                            isSidebarVisible = true;
                          },
                        );
                      },
                    ),
                ],
              ),
        bottomNavigationBar: BottomNavSection(
          onSend: (chat) => _handleSend(context, chat),
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    // Return listbuilder of all conversations
    return FutureBuilder<List<ConversationHistoryItemModel>>(
      future: _conversationHistoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        } else {
          final items = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients &&
                _scrollController.position.pixels !=
                    _scrollController.position.maxScrollExtent) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            }
          });
          return ListView.builder(
            controller: _scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final history = items[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      message: history.query,
                      isQuery: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            botParticipant.icon,
                            const SizedBox(width: 5),
                            Text(
                              botParticipant.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                        ChatBubble(
                          message: history.answer,
                          isQuery: false,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
