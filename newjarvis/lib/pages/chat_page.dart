import 'package:flutter/material.dart';
import 'package:newjarvis/components/bottom_nav_section.dart';
import 'package:newjarvis/components/chat_bubble.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/enums/id.dart';
import 'package:newjarvis/enums/model.dart';
import 'package:newjarvis/models/ai_chat_model.dart';
import 'package:newjarvis/models/ai_model.dart';
import 'package:newjarvis/models/assistant_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/models/chat_response_model.dart';
import 'package:newjarvis/models/conversation_history_item_model.dart';
import 'package:newjarvis/models/conversation_item_model.dart';
import 'package:newjarvis/providers/auth_provider.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/services/auth_gate.dart';
import 'package:newjarvis/services/auth_state.dart';
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
  ConversationHistoryItemModel _conversationHistory =
      ConversationHistoryItemModel(
    query: '',
    answer: '',
    files: [],
    createdAt: 0,
  );
  Future<List<ConversationHistoryItemModel>>? _conversationHistoryFuture;
  int selectedIndex = 0;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  double dragOffset = 200.0;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkLoginStatus();
    await _fetchAllConversations();
    _conversationHistoryFuture = _getAllConversationHistory(_conversations);
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
    }

    // Create AiChatModel
    final assistant = AssistantModel(
      id: Id.GPT_4_O.value,
      model: Model.dify.name,
    );

    AiChatModel message = AiChatModel(
      assistant: assistant,
      content: chat,
      files: null,
      metadata: null,
    );

    print('Sending message: $message');

    // Call ApiService to send chat
    try {
      await apiService.sendMessage(
        context: context,
        aiChat: message,
      );

      // Fetch the latest conversation history
      if (_conversations.isNotEmpty) {
        await _getConversationHistory(_conversations.first.id);
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending message: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return chat;
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

      setState(() {
        _conversationHistory = history;
      });

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: authProvider.currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(
                    right: isSidebarVisible ? (isExpanded ? 180 : 98) : 0,
                  ),
                  width: double.infinity,
                  child: _buildChatList(context),
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
        selectedModel: 'Monica',
        aiModels: [
          AIModel(name: 'Monica'),
          AIModel(name: 'Genius'),
          AIModel(name: 'Gemini'),
          AIModel(name: 'Claude-Instant-100k'),
          AIModel(name: 'Claude-2'),
          AIModel(name: 'Writing Agent'),
          AIModel(name: 'Auto Agent'),
          AIModel(name: 'Bard'),
          AIModel(name: 'Mistral-7b'),
          AIModel(name: 'Llama-2-70b'),
          AIModel(name: 'Codellama-34b'),
          AIModel(name: 'Instagram Post Generator'),
          AIModel(name: 'Twitter Post Generator'),
        ],
        selectedIndex: 0,
        onSend: (chat) => _handleSend(context, chat),
      ),
    );
  }

  Widget welcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, welcome abroad 🚀',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          // Horizontal Divider
          Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 1,
            height: 20,
          ),

          RichText(
            text: TextSpan(
              text:
                  "Jarvis KB is a cutting-edge AI App development platform designed. With Jarvis KB, you can effortlessly create and deploy various chatbots across numerous social platforms and messaging apps like Messenger, Telegram, and Slack!",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            "Why Choose Jarvis KB?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "We offer robust and flexible solutions to meet your chatbot development needs. Here's what makes Jarvis KB stand out:",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          const SizedBox(height: 16),

          _buildFeatureItem(
            icon: Icons.language,
            title: "Multi-Source Knowledge Integration 🌐",
            description:
                "Seamlessly integrate various types of knowledge from multiple data sources such as Websites, Google Drive, GitHub, GitLab, Notion, and more. This ensures your chatbot has access to a rich repository of information.",
          ),
          const SizedBox(height: 16),

          _buildFeatureItem(
            icon: Icons.code,
            title: "Comprehensive SDK 🛠️",
            description:
                "Our SDK provides the tools and resources needed to integrate chatbots into your own applications with ease.",
          ),
          const SizedBox(height: 16),

          _buildFeatureItem(
            icon: Icons.face,
            title: "User-Friendly Interface 🎨",
            description:
                "Designed with simplicity in mind, our platform allows both novice and experienced developers to create and manage chatbots without hassle.",
          ),

          const SizedBox(height: 16),

          _buildFeatureItem(
            icon: Icons.group,
            title: "Collaboration Features 🤝",
            description:
                "Collaborate with other bots to enhance functionality and provide a richer user experience. Jarvis KB enables multiple bots to work together seamlessly.",
          ),

          const SizedBox(height: 16),

          _buildFeatureItem(
            icon: Icons.bar_chart,
            title: "Scalable Solutions 📈",
            description:
                "Whether you're a small business or a large enterprise, our platform scales to meet your demands, ensuring reliable and efficient chatbot performance. 🌟",
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bullet
        Icon(
          Icons.brightness_1,
          size: 10,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),

        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ],
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No conversation history available.'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
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
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      message: history.answer,
                      isQuery: false,
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
