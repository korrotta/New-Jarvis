import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/components/widgets/chat_input_section.dart';
import 'package:newjarvis/models/ai_bot_model.dart';
import 'package:newjarvis/services/knowledge_api_service.dart';

class AssistantPage extends StatefulWidget {
  final AiBotModel selectedAssistant;

  const AssistantPage({
    super.key,
    required this.selectedAssistant,
  });

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  // Knowledge API Instance
  final KnowledgeApiService _knowledgeApiService = KnowledgeApiService();

  // AssistantId from previous screen
  late AiBotModel _assistant;

  @override
  void initState() {
    super.initState();
    _initAssistant();
  }

  void _initAssistant() {
    _assistant = widget.selectedAssistant;
  }

  void _showEditAssistantDialog() {
    // Show Edit Assistant Dialog
  }

  void _handleDocs() {}

  void _handlePublish() {}

  void _handleSendChat(String message) {
    // Handle sending message
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_back,
            size: 22,
          ),
          tooltip: 'Back',
          mouseCursor: WidgetStateMouseCursor.clickable,
          color: Theme.of(context).colorScheme.inversePrimary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: GestureDetector(
          onTap: () {
            // Handle Assistant Name tap
            _showEditAssistantDialog();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Tooltip(
              message: 'Edit Assistant',
              child: Text(
                _assistant.assistantName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
        actions: [
          // Docs Button
          ElevatedButton.icon(
            iconAlignment: IconAlignment.start,
            onPressed: _handleDocs,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            icon: Icon(
              CupertinoIcons.doc_text,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 18,
            ),
            label: Text(
              'Docs',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onHover: (value) {
              // Handle Docs button hover
              ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  color: value
                      ? Colors.blue
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: value
                        ? Colors.blue
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                iconColor: value
                    ? Colors.blue
                    : Theme.of(context).colorScheme.inversePrimary,
              );
            },
          ),

          const SizedBox(width: 8.0),

          // Publish Button
          ElevatedButton.icon(
            iconAlignment: IconAlignment.start,
            onPressed: _handlePublish,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            icon: Icon(
              CupertinoIcons.cloud_upload,
              color: Theme.of(context).colorScheme.tertiary,
              size: 18,
            ),
            label: Text(
              'Publish',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            onHover: (value) {
              // Handle Publish button hover
              ElevatedButton.styleFrom(
                backgroundColor: value
                    ? Theme.of(context).colorScheme.tertiary.withOpacity(0.8)
                    : Colors.blueAccent,
                shadowColor: value
                    ? Theme.of(context).colorScheme.tertiary.withOpacity(0.8)
                    : Colors.blueAccent,
                elevation: value ? 10 : 0,
              );
            },
          ),

          const SizedBox(width: 8.0),
        ],
      ),
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Develop Column
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.0,
                ),
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.0,
                ),
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.0,
                    )),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Develop',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),

                // Assistant Persona
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      scrollPhysics: const AlwaysScrollableScrollPhysics(),
                      decoration: InputDecoration(
                        hintText:
                            'Design the assistant\'s persona, features and workflows using natural language.',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Preview Column
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.0,
                    )),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 48.0,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Start a conversation with the assistant\nby typing a message in the input box below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                ChatInputSection(
                  onSend: (String message) {
                    // Handle sending message
                    _handleSendChat(message);
                  },
                  onNewConversation: () {
                    // Handle start new conversation
                    print('Start new conversation');
                  },
                ),
              ],
            ),
          ),
        ),
        // Knowledge Column
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.0,
                ),
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.0,
                ),
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.0,
                    )),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Knowledge',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
