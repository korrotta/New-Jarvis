import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/components/widgets/chat_bubble.dart';
import 'package:newjarvis/components/widgets/chat_input_section.dart';
import 'package:newjarvis/components/widgets/chat_participant.dart';
import 'package:newjarvis/components/widgets/custom_textfield.dart';
import 'package:newjarvis/models/ai_bot_model.dart';
import 'package:newjarvis/models/assistant_thread_message_model.dart';
import 'package:newjarvis/models/assistant_thread_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/models/message_text_content_model.dart';
import 'package:newjarvis/models/thread_message_content_model.dart';
import 'package:newjarvis/services/api_service.dart';
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
  // Api Service Instance
  ApiService _apiService = ApiService();

  // Knowledge API Instance
  final KnowledgeApiService _knowledgeApiService = KnowledgeApiService();

  // Current user
  BasicUserModel? _currentUser;

  // AssistantId from previous screen
  late AiBotModel _assistant;

  // All Threads
  List<AssistantThreadModel> _threads = [];

  // Current OpenAIThreadID
  String? _currentOpenAiThreadId;

  // Thread's Messages
  List<AssistantThreadMessageModel> _threadMessages = [];

  // List of thread's messages' contents
  List<ThreadMessageContentModel> _contents = [];

  // Flag to check if current thread is new
  bool _isNewThread = false;

  TextEditingController _assistantPersonaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAssistant();
  }

  void _initAssistant() async {
    _assistant = widget.selectedAssistant;
    await _getCurentUserInfo();
    await _fetchThreads();
  }

  Future<void> _getCurentUserInfo() async {
    final response = await _apiService.getCurrentUser(context);
    setState(() {
      _currentUser = response;
    });
  }

  void _showEditAssistantDialog(
      TextEditingController assistantNameController,
      TextEditingController assistantDescriptionController,
      BuildContext context) {
    // Show Edit Assistant Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text("Edit Assistant"),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text("Assistant name"),
              const SizedBox(height: 5),
              CustomTextfield(
                validator: (p0) => p0!.isEmpty ? "Name is required" : null,
                hintText: "",
                initialObscureText: false,
                controller: assistantNameController,
              ),
              const SizedBox(height: 15),
              const Text("Assistant description"),
              const SizedBox(height: 5),
              CustomTextfield(
                hintText: "",
                initialObscureText: false,
                controller: assistantDescriptionController,
              ),
              const SizedBox(height: 5),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                _editAssistant(assistantNameController,
                    assistantDescriptionController, context);
              },
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editAssistantPersona(String persona) async {
    // Handle Edit Assistant Persona
    final response = await _knowledgeApiService.updateAssistant(
      context: context,
      assistantId: _assistant.id,
      name: _assistant.assistantName,
      instructions: persona,
    );

    setState(() {
      _assistant = response;
    });

    // Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        elevation: 0,
        content:
            customSnackbar(false, "Assistant's persona updated successfully"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editAssistant(
      TextEditingController assistantNameController,
      TextEditingController assistantDescriptionController,
      BuildContext context) async {
    // Handle Edit Assistant
    final assistantName = assistantNameController.text;
    final assistantDescription = assistantDescriptionController.text;

    final response = await _knowledgeApiService.updateAssistant(
      context: context,
      assistantId: _assistant.id,
      name: assistantName,
      desc: assistantDescription,
    );

    setState(() {
      _assistant = response;
    });

    Navigator.of(context).pop();

    // Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        elevation: 0,
        content: customSnackbar(false, "Assistant updated successfully"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget customSnackbar(bool isError, String message) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isError ? "Error" : "Success",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16.0,
          child: Icon(
            isError ? Icons.error : Icons.check_circle,
            color: Colors.white,
            size: 48.0,
          ),
        )
      ],
    );
  }

  void _handleDocs() {}

  void _handlePublish() {}

  Future<void> _fetchThreads() async {
    // Fetch all threads
    final response = await _knowledgeApiService.getThreads(
      assistantId: _assistant.id,
      context: context,
    );

    setState(() {
      _threads = response;
    });

    if (_threads.isNotEmpty) {
      _currentOpenAiThreadId = _threads.first.openAiThreadId;
      _fetchThreadMessages(_currentOpenAiThreadId!);
    } else {
      _handleNewThread();
    }
  }

  Future<void> _fetchThreadMessages(String threadId) async {
    // Fetch all messages for a thread
    final response = await _knowledgeApiService.getMessages(
      openAiThreadId: threadId,
      context: context,
    );

    setState(() {
      _threadMessages = response;
    });
  }

  Future<void> _handleSendChat(BuildContext context, String message) async {
    // Handle sending message
    print('Sending message: $message');

    if (_isNewThread) {
      // Create new thread
      final response = await _knowledgeApiService.createThread(
        assistantId: _assistant.id,
        context: context,
        firstMessage: message,
      );

      setState(() {
        _currentOpenAiThreadId = response.openAiThreadId;
        _isNewThread = false;
      });

      // Ask Assistant
      final assistantResponse = await _knowledgeApiService.askAssistant(
        context: context,
        assistantId: _assistant.id,
        message: message,
        openAiThreadId: _currentOpenAiThreadId,
        additionalInstruction: "",
      );

      setState(() {
        _contents.add(ThreadMessageContentModel(
          type: 'text',
          text: MessageTextContentModel(value: assistantResponse),
        ));
      });

      if (assistantResponse.isNotEmpty) {
        final message = AssistantThreadMessageModel(
          content: _contents,
          createdAt: DateTime.now().millisecondsSinceEpoch.toInt(),
          role: _currentUser!.roles.first,
        );

        setState(() {
          _threadMessages.add(message);
        });
      }
    } else {
      final response = await _knowledgeApiService.askAssistant(
        context: context,
        assistantId: _assistant.id,
        message: message,
        openAiThreadId: _assistant.openAiThreadIdPlay,
        additionalInstruction: "",
      );

      setState(() {
        _contents.add(ThreadMessageContentModel(
          type: 'text',
          text: MessageTextContentModel(value: response),
        ));
      });

      if (response.isNotEmpty) {
        final message = AssistantThreadMessageModel(
          content: _contents,
          createdAt: DateTime.now().millisecondsSinceEpoch.toInt(),
          role: _currentUser!.roles.first,
        );

        setState(() {
          _threadMessages.add(message);
        });
      }
    }
    _fetchThreads();
  }

  Future<void> _handleNewThread() async {
    setState(() {
      _isNewThread = true;
      _currentOpenAiThreadId = "";
      _threads = [];
      _threadMessages = [];
      _contents = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildPageContent(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
          _showEditAssistantDialog(
            TextEditingController(text: _assistant.assistantName),
            TextEditingController(text: _assistant.description),
            context,
          );
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
                      controller: _assistantPersonaController,
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

                // Elevated Button
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle update assistant persona
                      _editAssistantPersona(_assistantPersonaController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    iconAlignment: IconAlignment.start,
                    icon: Icon(
                      CupertinoIcons.floppy_disk,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 18,
                    ),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
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
                      'Preview & Chat',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<AssistantThreadMessageModel>>(
                      future: Future.value(_threadMessages),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: _newThreadAssistantSection(context),
                          );
                        } else {
                          final items = snapshot.data!.reversed.toList();
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final history = items[index];
                              final role = history.role;
                              final displayContent =
                                  history.content[0]['text']['value'];
                              return Column(
                                crossAxisAlignment: role == 'assistant'
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 8.0),
                                  Container(
                                    margin: role == 'assistant'
                                        ? const EdgeInsets.only(
                                            left: 4.0,
                                          )
                                        : const EdgeInsets.only(
                                            right: 10.0,
                                          ),
                                    alignment: role == 'assistant'
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment: role == 'assistant'
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment: role == 'assistant'
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                          children: [
                                            role == 'assistant'
                                                ? botParticipant.icon
                                                : userParticipant.icon,
                                            const SizedBox(width: 5),
                                            Text(
                                              role == 'assistant'
                                                  ? _assistant.assistantName
                                                  : _currentUser!.getUsername,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ChatBubble(
                                          message: displayContent,
                                          isQuery: history.role == 'assistant',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                ),
                ChatInputSection(
                  onSend: (String message) {
                    _handleSendChat(context, message);
                  },
                  onNewConversation: () {
                    _handleNewThread();
                  },
                ),
                const SizedBox(height: 8.0),
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

                // FAB Add knowledge button
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    tooltip: 'Add Knowledge to Assistant',
                    onPressed: () {},
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(
                      CupertinoIcons.add,
                      color: Colors.white,
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

  Widget _newThreadAssistantSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/assistant.png',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 4.0),
        Text(
          _assistant.assistantName,
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Start a conversation with the assistant\nby typing a message in the input box below.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
