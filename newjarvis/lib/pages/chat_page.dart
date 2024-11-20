import 'package:flutter/material.dart';
import 'package:newjarvis/components/bottom_nav_section.dart';
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
import 'package:newjarvis/services/auth_state.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ApiService
  final ApiService apiService = ApiService();

  // List of conversations
  List<ConversationItemModel> _conversations = [];

  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkAndFetchConversations();
  }

  String _handleSend(BuildContext context, String chat) {
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
    Future<ChatResponseModel> chatResponse = apiService.sendMessage(
      context: context,
      aiChat: message,
    );

    return chatResponse.toString();
  }

  Future<void> _checkAndFetchConversations() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await _fetchAllConversations();
    } else {
      print('User is not logged in');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        print('Conversations: $_conversations');

        print('Latest Conversation: ${_conversations.first}');
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching conversation history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assistant = AssistantModel(
      id: Id.GPT_4_O.value,
      model: Model.dify.name,
    );
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    List<ConversationItemModel> conversations = [];
    List<ConversationHistoryItemModel> conversationHistory = [];

    return Scaffold(
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.secondary,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    welcomeSection(context),
                    const SizedBox(height: 20),
                    // Test get conversations
                    ElevatedButton(
                      onPressed: () async {
                        conversations = await apiService.getConversations(
                          context: context,
                          cursor: null,
                          limit: 15,
                          assistant: assistant,
                        );
                      },
                      child: Text('Get Conversations'),
                    ),
                    const SizedBox(height: 20),

                    // Test get latest conversation
                    ElevatedButton(
                      onPressed: () async {
                        print('Conversations: $conversations');
                        print('Latest Conversation: ${conversations.first}');
                        conversationHistory =
                            await apiService.getConversationHistory(
                          context: context,
                          conversationId: conversations.first.id,
                          cursor: null,
                          limit: 100,
                          assistant: assistant,
                        );
                      },
                      child: Text('Get Latest Conversation'),
                    ),
                    const SizedBox(height: 20),

                    signOutButton(context),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
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

  // Build chat list

  // Build chat item

  ElevatedButton signOutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        backgroundColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        // Handle signout here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Authentication();
            },
          ),
        );
        ApiService().signOut();
      },
      child: Text(
        'Sign out',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
