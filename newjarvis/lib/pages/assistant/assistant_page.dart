import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/pages/knowledge_base/knowledge_base_unit.dart';
import 'package:newjarvis/providers/knowledge_base_provider/knowledge_base_unit_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/chat_bubble.dart';
import 'package:newjarvis/components/ai_chat/chat_input_section.dart';
import 'package:newjarvis/components/widgets/chat_participant.dart';
import 'package:newjarvis/components/ai_assistant/thread_drawer.dart';
import 'package:newjarvis/models/assistant/ai_bot_model.dart';
import 'package:newjarvis/models/assistant/assistant_knowledge_model.dart';
import 'package:newjarvis/models/assistant/assistant_thread_message_model.dart';
import 'package:newjarvis/models/assistant/assistant_thread_model.dart';
import 'package:newjarvis/models/user/basic_user_model.dart';
import 'package:newjarvis/models/knowledge_base/knowledge_base_model.dart';
import 'package:newjarvis/models/assistant/message_text_content_model.dart';
import 'package:newjarvis/models/assistant/thread_message_content_model.dart';
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

  // Selected Knowledge
  String? _selectedKnowledgeId;

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

  @override
  void dispose() {
    _assistantPersonaController.dispose();
    _knowledgeTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initAssistant() async {
    _assistant = widget.selectedAssistant;
    _assistantPersonaController.text = _assistant.instructions ?? '';
    await _getCurentUserInfo();
    await _fetchThreads();
    if (_currentOpenAiThreadId?.isNotEmpty ?? false) {
      await _fetchThreadMessages(_currentOpenAiThreadId!);
    }
    await _getAssistantKnowledges();
  }

  void _initKnowledge() async {
    final response = await _knowledgeBaseApiService.getKnowledge();

    setState(() {
      _knowledges = response;
    });
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(parsedDate);
  }

  Future<void> _getAssistantKnowledges() async {
    final response = await _knowledgeApiService.getKnowledgeAssistant(
      context: context,
      assistantId: _assistant.id,
    );

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

  Widget _buildBadge(String label, Color color) {
    if (color == Colors.blueAccent) {
      label = '$label unit';
    } else if (color == Colors.redAccent) {
      label = '$label byte';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showImportKnowledgeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Center(
              child: Text(
                "Select Knowledge",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                Future<void> performSearch(String query) async {
                  try {
                    if (query == '' || query.isEmpty) {
                      final response =
                          await _knowledgeBaseApiService.getKnowledge();

                      setState(() {
                        _knowledges = response;
                      });

                      return;
                    }

                    final response =
                        await _knowledgeBaseApiService.getKnowledge(
                      query: query,
                    );

                    setState(() {
                      _knowledges = response;
                    });
                    return;
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        elevation: 0,
                        content:
                            customSnackbar(true, "Failed to search knowledge"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }

                void clearSearch() {
                  setState(() {
                    _knowledgeTextController.clear();
                  });
                  performSearch(''); // Trigger search with an empty query
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _knowledgeTextController,
                        onFieldSubmitted: (text) {
                          if (text == _knowledgeTextController.text) {
                            performSearch(text);
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () =>
                                performSearch(_knowledgeTextController.text),
                            icon: const Icon(
                              CupertinoIcons.search,
                              color: Colors.blueAccent,
                            ),
                          ),
                          suffixIcon: _knowledgeTextController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.clear,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: clearSearch,
                                )
                              : null,
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: (_knowledges.isEmpty || _knowledges == [])
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.folder,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "No Knowledge Found",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Add knowledge using the button below.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        CupertinoIcons.add,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 12),
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        shadowColor: Colors.black
                                            .withOpacity(0.2), // Button shadow
                                        elevation: 5,
                                      ),
                                      onPressed: () {
                                        // Navigate to Create Knowledge Page
                                        RouteController
                                            .navigateReplacementNamed(
                                                RouteController.knowledge);
                                      },
                                      label: const Text(
                                        "Knowledge",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _knowledges.length,
                                itemBuilder: (context, index) {
                                  final knowledge = _knowledges[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      border:
                                          knowledge.id == _selectedKnowledgeId
                                              ? Border.all(
                                                  color: Colors.blueAccent,
                                                  width: 2,
                                                )
                                              : Border.all(
                                                  color: Colors.transparent,
                                                  width: 2,
                                                ),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Image.asset(
                                          'assets/images/coins.png',
                                          width: 30,
                                          height: 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            _selectedKnowledgeId = knowledge.id;
                                          },
                                        );
                                      },
                                      title: Text(
                                        knowledge.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              _buildBadge(
                                                  knowledge.numUnits.toString(),
                                                  Colors.blueAccent),
                                              const SizedBox(width: 8),
                                              _buildBadge(
                                                  knowledge.totalSize
                                                      .toString(),
                                                  Colors.redAccent),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatDate(
                                                    knowledge.createdAt),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      foregroundColor: Colors.redAccent,
                      shadowColor: const Color.fromRGBO(0, 0, 0, 1)
                          .withOpacity(1), // Button shadow
                      elevation: 2,
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (_selectedKnowledgeId != null) {
                        _importKnowledgeToAssistant(_selectedKnowledgeId!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            elevation: 0,
                            content: customSnackbar(
                                true, "Select a knowledge first"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      shadowColor:
                          Colors.black.withOpacity(0.2), // Button shadow
                      elevation: 5,
                    ),
                    child: const Text(
                      "Import",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          );
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
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
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
                    maxLength: 2000,
                    maxLines: 5,
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
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  },
                );
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
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        );
      },
    );

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

    Navigator.of(context).pop();

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
          height: 55,
          decoration: BoxDecoration(
            color: isError ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              const SizedBox(width: 55.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
          left: 0.0,
          child: Icon(
            isError ? Icons.error : Icons.check_circle,
            color: Colors.white,
            size: 45.0,
          ),
        )
      ],
    );
  }

  Future<void> _importKnowledgeToAssistant(String knowledgeId) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        );
      },
    );

    // Import Knowledge to Assistant
    final response = await _knowledgeApiService.importKnowledge(
      context: context,
      assistantId: _assistant.id,
      knowledgeId: knowledgeId,
    );

    print("Imported Knowledge: $response");

    Navigator.of(context).pop();

    response ? await _getAssistantKnowledges() : null;

    // Show SnackBar
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          elevation: 0,
          content: customSnackbar(false, "Knowledge imported successfully"),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          elevation: 0,
          content: customSnackbar(true, "Knowledge is already imported"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _removeKnowledgeFromAssistant(String knowledgeId) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          );
        });
    // Remove Knowledge from Assistant
    final response = await _knowledgeApiService.removeKnowledge(
      context: context,
      assistantId: _assistant.id,
      knowledgeId: knowledgeId,
    );

    response ? await _getAssistantKnowledges() : null;

    Navigator.of(context).pop();

    // Show SnackBar
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          elevation: 0,
          content: customSnackbar(false, "Knowledge removed successfully"),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          elevation: 0,
          content: customSnackbar(true, "Failed to remove knowledge"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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

    if (_threads.isEmpty || _threads == []) {
      _handleNewThread();
    } else {
      _currentOpenAiThreadId = _threads.last.openAiThreadId;
    }
  }

  Future<void> _fetchThreadMessages(String threadId) async {
    print('Fetching thread messages for thread: $threadId');
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
    return SafeArea(
      top: true,
      child: Scaffold(
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
    final unitProvider = Provider.of<UnitProvider>(context, listen: false);
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
                    if (snapshot.hasError) {
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
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.asset(
                                  'assets/images/coins.png',
                                  width: 25,
                                  height: 25,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              title: Text(
                                knowledge.knowledgeName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              subtitle: Text(
                                _formatDate(knowledge.createdAt.toString()),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.eye,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    onPressed: () {
                                      // Navigate to Knowledge Page

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            ),
                                          );
                                        },
                                      );

                                      unitProvider.setKnowledgeDetails(
                                        name: knowledge.knowledgeName,
                                        id: knowledge.id,
                                        description: knowledge.description,
                                        units: _knowledges
                                            .where(
                                              (element) {
                                                return element.id ==
                                                    knowledge.id;
                                              },
                                            )
                                            .first
                                            .numUnits,
                                      );

                                      unitProvider
                                          .loadUnitListOfKnowledge()
                                          .then(
                                        (_) {
                                          // Đóng loading dialog
                                          Navigator.of(context).pop();

                                          // Chuyển sang màn hình mới
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const KnowledgeUnitScreen(),
                                            ),
                                          );
                                        },
                                      ).catchError(
                                        (error) {
                                          Navigator.of(context).pop();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                              elevation: 0,
                                              content: customSnackbar(
                                                  true, error.toString()),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.trash,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    onPressed: () {
                                      // Remove Knowledge from Assistant
                                      _removeKnowledgeFromAssistant(
                                              knowledge.id)
                                          .catchError(
                                        (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                              elevation: 0,
                                              content: customSnackbar(
                                                  true, error.toString()),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
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
                  // Reset the selected knowledge before opening the dialog
                  setState(() {
                    _selectedKnowledgeId = null;
                  });
                  // Handle Add Knowledge
                  _showImportKnowledgeDialog(context);
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
