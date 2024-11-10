import 'package:flutter/material.dart';
import 'package:newjarvis/components/bottom_nav_section.dart';
import 'package:newjarvis/models/ai_model.dart';
import 'package:newjarvis/services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        height: double.infinity,
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            signOutButton(context),
          ],
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
      ),
    );
  }

  Column welcomeSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // Emoji
          '👋\n'
          'Welcome',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'I\'m Monica, your persoal office assistant.\n'
          'I have these amazing powers:\n',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
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
        ApiService().signOut();
        Navigator.pushReplacementNamed(context, '/login');
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
