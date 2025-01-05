import 'package:flutter/material.dart';
import 'package:newjarvis/components/widgets/bottom_nav_section.dart';
import 'package:newjarvis/components/widgets/chat_bubble.dart';
import 'package:newjarvis/components/widgets/chat_participant.dart';
import 'package:newjarvis/components/widgets/conversation_drawer.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/components/ai_chat/welcome_chat_section.dart';
import 'package:newjarvis/enums/id.dart';
import 'package:newjarvis/models/ai_chat/ai_chat_metadata.dart';
import 'package:newjarvis/models/ai_chat/ai_chat_model.dart';
import 'package:newjarvis/models/assistant_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/models/ai_chat/chat_conversation.dart';
import 'package:newjarvis/models/ai_chat/chat_message.dart';
import 'package:newjarvis/models/ai_chat/conversation_history_item_model.dart';
import 'package:newjarvis/models/ai_chat/conversation_item_model.dart';
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
  // Api Service instance
  final ApiService _apiService = ApiService();

  // Current user
  BasicUserModel? _currentUser;

  // State variables
  String? _currentConversationId; // Nullable to handle new conversations

  ChatConversation _currentConversation = ChatConversation(
    id: '',
    messages: [],
  );

  List<ChatMessage> _messages = [];

  AiChatMetadata _metadata = AiChatMetadata(
    chatConversation: ChatConversation(
      id: '',
      messages: [],
    ),
  );

  bool _isNewThread = false; // Flag to track if it's a new thread

  // Storing conversations and conversation history
  List<ConversationItemModel> _conversations = []; // Store all conversations
  List<ConversationHistoryItemModel> _currentConversationHistory =
      []; // Store all current conversation history

  // UI State variables
  int _selectedIndex = 0;
  bool _isExpanded = false;
  bool _isSidebarVisible = false;
  bool _isDrawerVisible = false;
  double _dragOffset = 200.0;
  final ScrollController _scrollController = ScrollController();

  // Token usages
  String _remainingUsage = '0';
  String _totalUsage = '0';

  // Default AI
  AssistantModel _assistant = AssistantModel(
    id: Id.CLAUDE_3_HAIKU_20240307.value,
  );

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkLoginStatus();
    await _getCurentUserInfo();
    await _fetchAllConversations(isInitialFetch: true);
    if (_currentConversationId != null) {
      await _getConversationHistory(_currentConversationId!);
    }
    await _fetchRemainingUsage();
    await _fetchTotalTokens();
    // await _scrollToBottom();
    print('Current Conversation ID: $_currentConversationId');
  }

  Future<void> _getCurentUserInfo() async {
    final response = await _apiService.getCurrentUser(context);
    setState(() {
      _currentUser = response;
    });
  }

  // Future<void> _scrollToBottom() async {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSidebarVisible = false;
    });

    // Navigate to the selected page
    RouteController.navigateTo(index);
  }

  // // Handle send message to AI (continue conversation)
  // Future<String> _handleSend(BuildContext context, String chat) async {
  //   if (chat.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Please enter a message',
  //           style: TextStyle(color: Colors.white, fontSize: 16),
  //         ),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //     return chat;
  //   }

  //   // Create placeholders for the conversation
  //   final tempConversation = ConversationHistoryItemModel(
  //     query: chat,
  //     answer: '', // Placeholder for AI's response
  //     files: [],
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //   );

  //   // Add placeholder to the conversation history
  //   setState(() {
  //     _conversationHistory = _conversationHistory!
  //         .then((history) => [...history, tempConversation]);
  //   });

  //   await _scrollToBottom();

  //   try {
  //     // Call API to send the message and receive a response
  //     final response = await apiService.sendMessage(
  //       context: context,
  //       aiChat: AiChatModel(
  //         assistant: _assistant,
  //         content: chat,
  //         files: null,
  //         metadata: null, // Pass metadata if conversation ID exists
  //       ),
  //     );

  //     // Update the last message with AI's response
  //     setState(() {
  //       _fetchRemainingUsage();
  //       _fetchTotalTokens();
  //       // Refresh conversation history
  //       _fetchAllConversations();
  //       _conversationHistory = _conversationHistory!.then((history) {
  //         // Replace the placeholder with the final response
  //         final updatedHistory =
  //             List<ConversationHistoryItemModel>.from(history);
  //         updatedHistory.last = ConversationHistoryItemModel(
  //           query: chat,
  //           answer: response.message ??
  //               '', // Use actual AI response or empty string if null
  //           files: [],
  //           createdAt: tempConversation.createdAt,
  //         );

  //         return updatedHistory;
  //       });
  //     });

  //     await _scrollToBottom();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error sending message: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }

  //   return chat;
  // }

  // Function to handle sending messages
  Future<void> _handleSend(String message) async {
    setState(() {
      // Append the message to the current conversation thread
      ChatMessage chatMessage = ChatMessage(
        assistant: _assistant,
        content: message,
        files: [],
        role: _currentUser!.roles.first,
      );
      _messages.add(chatMessage);

      if (_currentConversationId != null) {
        _metadata = AiChatMetadata(
          chatConversation: ChatConversation(
            id: _currentConversationId!,
            messages: _messages,
          ),
        );
      }
    });

    // Send the message to the AI
    try {
      final response = await _apiService.sendMessage(
        context: context,
        aiChat: AiChatModel(
          assistant: _assistant,
          content: message,
          files: null,
          metadata: _isNewThread ? null : _metadata,
        ),
      );

      print('Response _handleSend: $response');

      setState(() {
        // Reset the new thread flag
        _isNewThread = false;
      });

      // Fetch all conversations
      _fetchAllConversations();

      // Update current conversation history
      _getConversationHistory(_currentConversationId!);

      // Update token usages
      _fetchRemainingUsage();
      _fetchTotalTokens();
    } catch (e) {
      // Error sending message
    }
  }

  // Function to handle starting a new thread
  void _handleNewConversation() {
    setState(() {
      _isNewThread = true;
      _messages.clear(); // Clear the previous conversation messages
      _conversations.clear(); // Clear the previous conversations
      _currentConversationHistory
          .clear(); // Clear the previous conversation history
      _currentConversationId = null; // Reset conversation ID
    });
  }

  // Fetch remaining usage
  Future<void> _fetchRemainingUsage() async {
    try {
      final TokenUsageModel tokenUsage = await _apiService.getTokenUsage();
      setState(() {
        _remainingUsage = tokenUsage.remainingTokens;
      });
    } catch (e) {
      // Error fetching remaining tokens
    }
  }

  // Fetch total tokens
  Future<void> _fetchTotalTokens() async {
    try {
      final TokenUsageModel tokenUsage = await _apiService.getTokenUsage();
      setState(() {
        _totalUsage = tokenUsage.totalTokens;
      });
    } catch (e) {
      // Error fetching total tokens
    }
  }

  // Check login status
  Future<bool> _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.currentUser != null;
  }

  // Fetch all conversations
  Future<void> _fetchAllConversations({bool isInitialFetch = false}) async {
    try {
      final response = await _apiService.getConversations(
        context: context,
        limit: 100,
        assistant: _assistant,
      );

      if (response.items.isEmpty) {
        _handleNewConversation();
        return;
      }

      setState(() {
        if (isInitialFetch) {
          _conversations = response.items; // Initial fetch
          // Sort the conversations by the latest message
          _conversations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Set the current conversation ID to the first conversation
          _currentConversationId = _conversations.first.id;
        } else {
          _conversations.addAll(response.items);
          // Sort the conversations by the latest message
          _conversations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Set the current conversation ID to the first conversation
          _currentConversationId = _conversations.first.id;
        }
      });
    } catch (e) {
      // Error fetching conversations
    }
  }

  // Get conversation history based on conversationID
  Future<void> _getConversationHistory(String conversationId) async {
    try {
      final response = await _apiService.getConversationHistory(
        context: context,
        conversationId: conversationId,
        limit: 100,
        assistant: _assistant,
      );

      setState(() {
        _currentConversationHistory = response;
      });

      // _scrollToBottom();
      return;
    } catch (e) {
      // Error fetching conversation history
    }

    return;
  }

  // Handle Selected AI from BottomNavSection
  void _handleSelectedAI(BuildContext context, String aiId) {
    setState(() {
      _assistant.id = aiId;
    });

    // Fetch all conversations
    _fetchAllConversations();
    // Fetch token usage
    _fetchRemainingUsage();
    _fetchTotalTokens();
  }

  void _handleConversationSelect(String id) {
    // Get the conversation history based on the selected conversation ID
    _getConversationHistory(id);

    setState(() {
      // Update the current conversation ID
      _currentConversationId = id;
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
                      left: _isDrawerVisible ? 250 : 0,
                      right: _isSidebarVisible ? (_isExpanded ? 180 : 98) : 0,
                    ),
                    width: double.infinity,
                    child: _buildChatList(context),
                  ),

                  // Conversation Drawer
                  ConversationSidebar(
                    conversations: _conversations,
                    onSelectedConversation: _handleConversationSelect,
                    remainingTokens: _remainingUsage,
                    totalTokens: _totalUsage,
                  ),

                  // Sidebar
                  if (_isSidebarVisible)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: SideBar(
                        isExpanded: _isExpanded,
                        selectedIndex: _selectedIndex,
                        onItemSelected: _onItemTapped,
                        onExpandToggle: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        onClose: () {
                          setState(() {
                            _isSidebarVisible = false;
                          });
                        },
                      ),
                    ),

                  // Nửa hình tròn khi sidebar bị ẩn (Floating Button)
                  if (!_isSidebarVisible)
                    FloatingButton(
                      dragOffset: _dragOffset,
                      onDragUpdate: (delta) {
                        setState(
                          () {
                            _dragOffset += delta;
                            if (_dragOffset < 0) _dragOffset = 0;
                            if (_dragOffset >
                                MediaQuery.of(context).size.height - 100) {
                              _dragOffset =
                                  MediaQuery.of(context).size.height - 100;
                            }
                          },
                        );
                      },
                      onTap: () {
                        setState(
                          () {
                            _isSidebarVisible = true;
                          },
                        );
                      },
                    ),
                ],
              ),
        bottomNavigationBar: BottomNavSection(
          onSend: (chat) => _handleSend(chat),
          onNewConversation: () => _handleNewConversation(),
          onAiSelected: (aiId) => _handleSelectedAI(context, aiId),
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    // Return listbuilder of all conversations
    return FutureBuilder<List<ConversationHistoryItemModel>>(
      future: Future.value(_currentConversationHistory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: WelcomeChatSection(),
          );
        } else {
          final items = snapshot.data!;
          // _scrollToBottom();
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
