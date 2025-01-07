import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/chat_bubble.dart';
import 'package:newjarvis/components/widgets/chat_input_section.dart';
import 'package:newjarvis/components/widgets/chat_participant.dart';
import 'package:newjarvis/components/widgets/conversation_drawer.dart';
import 'package:newjarvis/components/widgets/thread_drawer.dart';
import 'package:newjarvis/models/ai_bot_model.dart';
import 'package:newjarvis/models/assistant_knowledge_model.dart';
import 'package:newjarvis/models/assistant_thread_message_model.dart';
import 'package:newjarvis/models/assistant_thread_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/models/knowledge_base_model.dart';
import 'package:newjarvis/models/message_text_content_model.dart';
import 'package:newjarvis/models/thread_message_content_model.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/services/kbase_knowledge_service.dart';
import 'package:newjarvis/services/knowledge_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Docs URL
  final String _docsUrl = 'https://jarvis.cx/help/knowledge-base/publish-bot/';

  // Knowledge API Instance
  final KnowledgeApiService _knowledgeApiService = KnowledgeApiService();
  final KnowledgeBaseApiService _knowledgeBaseApiService =
      KnowledgeBaseApiService();

  // Current user
  BasicUserModel? _currentUser;

  // AssistantId from previous screen
  late AiBotModel _assistant;

  // All Threads
  List<AssistantThreadModel> _threads = [];

  // Current OpenAIThreadID
  String? _currentOpenAiThreadId;

  // List of knowledges
  List<Knowledge> _knowledges = [];

  // List of assistant's knowledges
  Future<List<AssistantKnowledgeModel>>? _assistantKnowledges;

  // Thread's Messages
  Future<List<AssistantThreadMessageModel>>? _threadMessages;

  // List of thread's messages' contents
  List<ThreadMessageContentModel> _contents = [];

  // Flag to check if current thread is new
  bool _isNewThread = false;

  // Scroll Controller
  ScrollController _scrollController = ScrollController();

  // Assistant Persona Controller
  TextEditingController _assistantPersonaController = TextEditingController();

  // Knowledge Text Controller
  TextEditingController _knowledgeTextController = TextEditingController();

  // For bottom nav
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initAssistant();
    _initKnowledge();
  }

  void _initAssistant() async {
    _assistant = widget.selectedAssistant;
    _assistantPersonaController.text = _assistant.instructions ?? '';
    await _getCurentUserInfo();
    await _fetchThreads();
    await _fetchThreadMessages(_currentOpenAiThreadId!);
    await _getAssistantKnowledges();
  }

  void _initKnowledge() async {
    final response = await _knowledgeBaseApiService.getKnowledge();

    setState(() {
      _knowledges = response;
    });

    print('Knowledges created: $_knowledges');
  }

  Future<void> _getAssistantKnowledges() async {
    final response = await _knowledgeApiService.getKnowledgeAssistant(
      context: context,
      assistantId: _assistant.id,
    );

    print('Assistant Knowledges: $response');

    setState(() {
      _assistantKnowledges = Future.value(response);
    });
  }

  Future<void> _getCurentUserInfo() async {
    final response = await _apiService.getCurrentUser(context);
    setState(() {
      _currentUser = response;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    });
  }

  Widget _showImportKnowledgeDialog(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text("Select Knowledge"),
      contentPadding: const EdgeInsets.all(20.0),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2, // Adjust flex as needed
                  child: TextFormField(
                    controller: _knowledgeTextController,
                    maxLength: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.blueAccent,
                      ),
                      hintText: "Search knowledge",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 8), // Add spacing between TextField and button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to Create Knowledge Page
                    RouteController.navigateReplacementNamed(
                        RouteController.knowledge);
                  },
                  child: const Text(
                    "Create Knowledge",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Add spacing between row and the list

            // Fetched Knowledges
            Expanded(
              child: ListView.builder(
                itemCount: _knowledges.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      CupertinoIcons.book,
                      color: Colors.redAccent,
                    ),
                    title: Text(_knowledges[index].name),
                    subtitle: Text(
                      _knowledges[index].createdAt,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.eye,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.trash,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
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
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "Assistant name",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Name cannot be empty" : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: assistantNameController,
                    maxLength: 50,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Enter a name",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) {
                      return Text(
                        "$currentLength / 50",
                        style: TextStyle(
                          color: isFocused
                              ? Colors.blueAccent
                              : Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Assistant description",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: assistantDescriptionController,
                    maxLines: 2000,
                    decoration: InputDecoration(
                      hintText: "Enter a description",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) {
                      return Text(
                        "$currentLength / 2000",
                        style: TextStyle(
                          color: isFocused
                              ? Colors.blueAccent
                              : Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              const SizedBox(width: 55.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isError ? "Error" : "Success",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 10.0,
          bottom: 10.0,
          left: 5.0,
          child: Icon(
            isError ? Icons.error : Icons.check_circle,
            color: Colors.white,
            size: 40.0,
          ),
        )
      ],
    );
  }

  Future<void> _handleDocs() async {
    // Open browser to link
    if (!await launchUrl(Uri.parse(_docsUrl))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          elevation: 0,
          content: customSnackbar(true, "Failed to open link"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

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
      _currentOpenAiThreadId = _threads.last.openAiThreadId;
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
      _threadMessages = Future.value(response);
    });

    _scrollToBottom();
  }

  Future<void> _handleSendChat(BuildContext context, String message) async {
    // Handle sending message
    print('Sending message: $message');
    // Append assistant message ('...') and user message
    List<AssistantThreadMessageModel>? currentThreadMessages =
        await _threadMessages;

    final userMessage = AssistantThreadMessageModel(
      content: [
        ThreadMessageContentModel(
          type: 'text',
          text: MessageTextContentModel(value: message),
        ),
      ],
      createdAt: DateTime.now().millisecondsSinceEpoch,
      role: _currentUser!.roles.first,
    );

    final assistantMessage = AssistantThreadMessageModel(
      content: [
        ThreadMessageContentModel(
          type: 'text',
          text: MessageTextContentModel(value: '...'),
        ),
      ],
      createdAt: DateTime.now().millisecondsSinceEpoch,
      role: 'assistant',
    );

    if (currentThreadMessages != null && currentThreadMessages.isNotEmpty) {
      print('Not empty');
      currentThreadMessages.insert(0, userMessage);
      currentThreadMessages.insert(0, assistantMessage);
    } else {
      print('Empty');
      currentThreadMessages = [assistantMessage, userMessage];
    }

    setState(() {
      _threadMessages = Future.value(currentThreadMessages);
    });

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
        additionalInstruction: _assistant.instructions ?? '',
      );

      setState(() {
        _contents.add(ThreadMessageContentModel(
          type: 'text',
          text: MessageTextContentModel(value: assistantResponse),
        ));
      });
    } else {
      final response = await _knowledgeApiService.askAssistant(
        context: context,
        assistantId: _assistant.id,
        message: message,
        openAiThreadId: _currentOpenAiThreadId,
        additionalInstruction: _assistant.instructions ?? '',
      );

      setState(() {
        _contents.add(ThreadMessageContentModel(
          type: 'text',
          text: MessageTextContentModel(value: response),
        ));
      });
    }
    _fetchThreads();
    _fetchThreadMessages(_currentOpenAiThreadId!);
  }

  Future<void> _handleNewThread() async {
    setState(() {
      _isNewThread = true;
      _currentOpenAiThreadId = '';
      _threadMessages = Future.value([]);
      _contents = [];
    });
  }

  void _handleThreadSelect(String openAiThreadId) {
    setState(() {
      _currentOpenAiThreadId = openAiThreadId;

      _isNewThread = false;
    });

    _fetchThreadMessages(openAiThreadId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: (_selectedIndex == 1)
          ? Drawer(
              elevation: 0,
              child: ThreadDrawer(
                threads: _threads,
                onSelectedThread: _handleThreadSelect,
              ),
            )
          : null,
      appBar: _buildAppBar(context),
      body: _getSelectedPage(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        selectedLabelStyle: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Develop',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.chat_bubble_text,
            ),
            label: 'Preview',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.book_circle_fill,
            ),
            label: 'Knowledge',
          ),
        ],
      ),
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
      title: GestureDetector(
        onTap: () {
          // Handle Assistant Name tap
          _showEditAssistantDialog(
            TextEditingController(text: _assistant.assistantName),
            TextEditingController(text: _assistant.description),
            context,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _assistant.assistantName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              CupertinoIcons.square_pencil,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 22,
            ),
          ],
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tooltip: 'Options',
          onSelected: (value) {
            if (value == 'Docs') {
              _handleDocs();
            } else if (value == 'Publish') {
              _handlePublish();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Docs',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Docs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Publish',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.cloud_upload,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Publish',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getSelectedPage(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _developSection(context);
      case 1:
        return _previewSection(context);
      case 2:
        return _knowledgeSection(context);
      default:
        return _previewSection(context);
    }
  }

  Container _knowledgeSection(BuildContext context) {
    return Container(
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
        children: [
          const SizedBox(height: 8.0),

          // Knowledge Section
          Expanded(
            child: FutureBuilder<List<AssistantKnowledgeModel>>(
              future: _assistantKnowledges,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  case ConnectionState.active:
                    return const Center(
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      )),
                    );

                  case ConnectionState.done:
                    if (snapshot!.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      // Empty
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty-folder.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'No knowledge found',
                              style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Add knowledge to the assistant\nby clicking the button below.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final AssistantKnowledgeModel knowledge =
                              snapshot.data![index];
                          return ListTile(
                            leading: const Icon(
                              CupertinoIcons.book,
                              color: Colors.redAccent,
                            ),
                            title: Text(knowledge.knowledgeName),
                            subtitle: Text(
                              DateFormat.yMMMd().format(knowledge.createdAt),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.eye,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.trash,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),

          // FAB Add knowledge button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 15.0, bottom: 15.0),
              child: FloatingActionButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tooltip: 'Add Knowledge to Assistant',
                onPressed: () {
                  // Handle Add Knowledge
                  showDialog(
                    context: context,
                    builder: (context) {
                      return _showImportKnowledgeDialog(context);
                    },
                  );
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _previewSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16.0,
            left: 16.0,
            child: FloatingActionButton.small(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder<List<AssistantThreadMessageModel>>(
                    future: _threadMessages,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          );
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          );
                        case ConnectionState.active:
                          return const Center(
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            )),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return Center(
                              child: _newThreadAssistantSection(context),
                            );
                          } else {
                            final items = snapshot.data!.reversed.toList();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToBottom();
                            });
                            return ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final AssistantThreadMessageModel history =
                                    items[index];
                                final role = history.role;
                                final List<ThreadMessageContentModel>
                                    displayContent = history.content;
                                final displayText =
                                    displayContent.first.text.value;
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
                                            mainAxisAlignment:
                                                role == 'assistant'
                                                    ? MainAxisAlignment.start
                                                    : MainAxisAlignment.end,
                                            children: [
                                              role == 'assistant'
                                                  ? botParticipant.icon
                                                  : userParticipant.icon,
                                              if (role == 'assistant')
                                                const SizedBox(width: 5.0),
                                              Text(
                                                role == 'assistant'
                                                    ? _assistant.assistantName
                                                    : '',
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
                                            message: displayText,
                                            isQuery: history.role == 'user',
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChatInputSection(
                    onSend: (String message) {
                      _handleSendChat(context, message);
                    },
                    onNewConversation: () {
                      _handleNewThread();
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _developSection(BuildContext context) {
    return Container(
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
          const SizedBox(height: 8.0),

          // Assistant Persona
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _assistant.instructions != null
                    ? _assistantPersonaController
                    : TextEditingController(),
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
    );
  }

  Widget _newThreadAssistantSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/assistant.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 4.0),
        Text(
          _assistant.assistantName,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
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
