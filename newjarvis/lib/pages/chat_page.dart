import 'package:flutter/material.dart';
import 'package:newjarvis/components/bottom_nav_section.dart';
import 'package:newjarvis/models/ai_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/components/chat_bubble.dart';
import 'package:newjarvis/services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ApiService
  final ApiService apiService = ApiService();

  String _handleSend(String chat) {
    // Call ApiService to send chat
    print(chat);
    return chat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.secondary,
        child: SingleChildScrollView(
          child: Column(
            children: [
              welcomeSection(context),
              signOutButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavSection(
        selectedModel: 'All',
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
        onSend: _handleSend,
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
  Widget _buildChatItem(String chat, BuildContext context) {
    final isUser = false;
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isUser
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Chat bubble
          ChatBubble(
            message: chat,
            isCurrentUser: isUser,
          ),
        ],
      ),
    );
  }

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
        Navigator.pushNamed(context, '/login');
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
