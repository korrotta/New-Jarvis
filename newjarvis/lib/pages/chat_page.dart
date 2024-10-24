import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/components/bottom_nav_section.dart';
import 'package:newjarvis/components/end_drawer_section.dart';
import 'package:newjarvis/components/writing_agent_section.dart';
import 'package:newjarvis/components/ai_search_section.dart';
import 'package:newjarvis/components/personalize_section.dart';
import 'package:newjarvis/components/upload_section.dart';
import 'package:newjarvis/models/ai_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String selectedModel;

  final List<AIModel> aiModels = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 45),
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        // Empty AppBar
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
        ),
        endDrawer: const EndDrawerSection(),

        // Monica Chat Section
        body: Container(
          height: double.infinity,
          color: Theme.of(context).colorScheme.secondary,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome Text
                  welcomeSection(context),

                  // Personalize Monica Section
                  const PersonalizeSection(),

                  // SizedBox
                  const SizedBox(height: 20),

                  // AI Search Section
                  const AiSearchSection(),

                  // SizedBox
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Upload Section
                      const UploadSection(),

                      // Writing Agent Section
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const WritingAgentSection(),
                          autoAgentSection(context),
                        ],
                      ),
                    ],
                  ),

                  // SizedBox
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),

        // Set Default AI Model to the first model in the list
        restorationId: selectedModel = aiModels[0].name,

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavSection(
          selectedModel: selectedModel,
          aiModels: aiModels,
          selectedIndex: 0,
        ),
      ),
    );
  }

  Column welcomeSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // emoji
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

  ElevatedButton autoAgentSection(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        backgroundColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        // Handle Auto Agent action
      },
      child: Text(
        'Auto Agent',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
