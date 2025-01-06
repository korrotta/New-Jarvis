import 'package:flutter/material.dart';
import 'package:newjarvis/components/widgets/bottom_nav_section.dart';
import 'package:newjarvis/components/widgets/chat_bubble.dart';
import 'package:newjarvis/components/widgets/chat_participant.dart';
import 'package:newjarvis/components/widgets/conversation_drawer.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/scroll_to_bottom_fab.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/components/ai_chat/welcome_chat_section.dart';
import 'package:newjarvis/enums/id.dart';
import 'package:newjarvis/models/ai_chat/ai_chat_metadata.dart';
import 'package:newjarvis/models/ai_chat/ai_chat_model.dart';
import 'package:newjarvis/models/ai_chat/chat_response_model.dart';
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

  ChatResponseModel? _chatResponse;

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
  Future<List<ConversationHistoryItemModel>>?
      _currentConversationHistory; // Store all current conversation history

  // UI State variables
  int _selectedIndex = 0;
  bool _isExpanded = false;
  bool _isSidebarVisible = false;
  double _dragOffset = 200.0;
  final ScrollController _scrollController = ScrollController();

  // Token usages
  String _remainingUsage = '0';
  String _totalUsage = '0';

  // Default AI
  AssistantModel _assistant = AssistantModel(
    id: Id.CLAUDE_3_HAIKU_20240307.value,
  );

  bool _showScrollToBottom = false;

  void _updateScrollVisibility() {
    if (_scrollController.hasClients) {
      setState(() {
        _showScrollToBottom = _scrollController.offset <
            _scrollController.position.maxScrollExtent - 100;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollVisibility);
    _initializePage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    // _scrollToBottom();
  }

  Future<void> _getCurentUserInfo() async {
    final response = await _apiService.getCurrentUser(context);
    setState(() {
      _currentUser = response;
    });
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSidebarVisible = false;
    });

    // Navigate to the selected page
    RouteController.navigateTo(index);
  }

  // Function to handle sending messages
  Future<void> _handleSend(String message) async {
    // Continue the conversation if there's a previous response
    if (_chatResponse != null) {
      _metadata = AiChatMetadata(
        chatConversation: ChatConversation(
          id: _chatResponse!.id,
        ),
      );
    }
    // Else check if current conversation is a new thread
    else if (!_isNewThread) {
      _metadata = AiChatMetadata(
        chatConversation: ChatConversation(
          id: _currentConversationId!,
        ),
      );
    }

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

        // Update the current conversation ID if it's a new thread
        _currentConversationId ??= response.id;

        // Current chat response (used for continuous conversation)
        _chatResponse = ChatResponseModel(
          id: response.id,
          message: response.message,
          remainingUsage: response.remainingUsage,
        );
      });

      // Fetch all conversations
      await _fetchAllConversations();

      // Update current conversation history
      await _getConversationHistory(_currentConversationId!);

      // Update token usages
      await _fetchRemainingUsage();
      await _fetchTotalTokens();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
      _currentConversationHistory =
          Future.value([]); // Clear the previous conversation history
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
          _conversations = response.items;
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
        assistant: _assistant,
      );

      setState(() {
        _currentConversationHistory = Future.value(response);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
        drawer: // Conversation Drawer
            Drawer(
          child: ConversationSidebar(
            conversations: _conversations,
            onSelectedConversation: _handleConversationSelect,
            remainingTokens: _remainingUsage,
            totalTokens: _totalUsage,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shadowColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _fetchAllConversations();
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
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
                      left: 0,
                      right: _isSidebarVisible ? (_isExpanded ? 180 : 98) : 0,
                    ),
                    width: double.infinity,
                    child: _buildChatList(context),
                  ),

                  // FAB for scrolling to bottom
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ScrollToBottomFAB(
                        onPressed: _scrollToBottom,
                        isVisible: _showScrollToBottom,
                      ),
                    ),
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
      future: _currentConversationHistory,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ));
          case ConnectionState.none:
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ));
          case ConnectionState.waiting:
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ));
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ));
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: WelcomeChatSection(),
              );
            } else {
              final items = snapshot.data!;
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                scrollDirection: Axis.vertical,
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
        }
      },
    );
  }
}
