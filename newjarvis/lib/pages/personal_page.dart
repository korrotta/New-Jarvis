import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/components/ai_assistant/empty_assistant_section.dart';
import 'package:newjarvis/components/widgets/custom_dropdownmenu.dart';
import 'package:newjarvis/components/widgets/custom_textfield.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/models/ai_bot_model.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/services/knowledge_api_service.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  // List of assistants
  List<AiBotModel> _assistants = [];

  // API Service Instance
  final ApiService _apiService = ApiService();

  // Knowledge API Service
  final KnowledgeApiService _knowledgeApiService = KnowledgeApiService();

  // Current user
  BasicUserModel? _currentUser;

  // Text Editing Controllers
  TextEditingController _assistantNameController = TextEditingController();
  TextEditingController _assistantDescriptionController =
      TextEditingController();
  TextEditingController _searchController = TextEditingController();

  // Search Text
  String _searchText = "";

  // Selected Filter
  String _selectedFilter = "All";

  // UI Variables
  int _selectedIndex = 1;
  bool _isExpanded = false;
  bool _isSidebarVisible = false;
  double _dragOffset = 200.0;
  bool _isHovered = false;

  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    // Auto login to the knowledge API
    await _loginKnowledgeApi();

    // Get current user
    await _getCurrentUser();

    // Fetch assistants
    await _getAssistants();
  }

  Future<void> _getCurrentUser() async {
    final response = await _apiService.getCurrentUser(context);
    setState(() {
      _currentUser = response;
    });
  }

  Future<void> _getAssistants() async {
    try {
      final fetchedAssistants =
          await _knowledgeApiService.getAssistants(context: context);
      setState(() {
        _assistants = fetchedAssistants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load assistants: $e')),
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

  Future<void> _loginKnowledgeApi() async {
    try {
      await _knowledgeApiService.signIn();
      print('Successfully logged in to the knowledge API');
    } catch (e) {
      print('Error during auto login: $e');
    }
  }

  Future<void> _performSearchAndFilter(String text, String filter) async {
    print('Searching for: $text and filtering by: $filter');
    setState(() {
      _selectedFilter = filter;
    });

    try {
      final result = await _knowledgeApiService.getAssistants(
        context: context,
        query: text,
        isFavorite: _selectedFilter.contains('Favorite'),
        isPublished: _selectedFilter.contains('Published'),
      );
      print('Search and filter result: $result');

      setState(() {
        _assistants = result;
      });
    } catch (e) {
      print('Search and filter error: $e');
    }
  }

  Future<void> _deleteAssistant(String id) async {
    try {
      await _knowledgeApiService.deleteAssistant(
          context: context, assistantId: id);
      _getAssistants();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete assistant: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(top: 20),
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the layout adjusts for the keyboard
        body: _currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  AnimatedContainer(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(
                      right: _isSidebarVisible ? (_isExpanded ? 180 : 98) : 0,
                    ),
                    width: double.infinity,
                    child: _buildPageContent(context),
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
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.smart_toy_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(width: 15),
                Text(
                  "AI Assistant",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            // Display current user name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: _currentUser?.username != null
                      ? Text(
                          _currentUser!.username![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentUser?.username ?? "Unknown",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentUser?.email ?? "Unknown",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Create Assistant & Filter Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dropdown and Search Bar
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomDropdownmenu(
                      dropdownItems: const ["All", "Favorite", "Published"],
                      onSelected: (item) {
                        print('Selected: $item');
                        setState(() {
                          _selectedFilter = item!;
                        });
                        _performSearchAndFilter(_searchText, _selectedFilter);
                      },
                      headingText: "Type: ",
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    flex: 5,
                    child: CustomTextfield(
                      hintText: "Search",
                      initialObscureText: false,
                      controller: _searchController,
                      onChanged: (text) {
                        setState(() {
                          _searchText = text;
                        });
                        _performSearchAndFilter(text, _selectedFilter);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Create button
            ElevatedButton.icon(
              onPressed: () {
                // Show the create bot dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    // Dialog include (title, assistant name*, assistant description, create button, cancel button)
                    return _showCreateDialog(_assistantNameController,
                        _assistantDescriptionController, context);
                  },
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Create bot",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 55),
                backgroundColor: Colors.blueAccent,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // List of assistants
        Expanded(
          child: _buildAssistantList(),
        ),
      ],
    );
  }

  Widget _showCreateDialog(
      TextEditingController assistantNameController,
      TextEditingController assistantDescriptionController,
      BuildContext context) {
    return AlertDialog(
      title: const Text("Create Assistant"),
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
            _createNewAssistant(assistantNameController,
                assistantDescriptionController, context);
          },
          child: const Text(
            "Create",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _navigateToAssistantDetails(String assistantId) {
    // Navigate to the assistant details page
    print('Navigate to assistant details: $assistantId');
    RouteController.navigateToPage(RouteController.assistant, arguments: {
      'assistantId': assistantId,
    });
  }

  Widget _buildAssistantList() {
    return FutureBuilder<List<AiBotModel>>(
      future: Future.value(_assistants),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const EmptyAssistantSection(),
                ElevatedButton.icon(
                  onPressed: () {
                    // Show the create bot dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return _showCreateDialog(
                          _assistantNameController,
                          _assistantDescriptionController,
                          context,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Create Bot Now",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 55),
                    backgroundColor: Colors.blueAccent,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          final items = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final assistant = items[index];
              return StatefulBuilder(
                builder: (context, setState) => MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  cursor: SystemMouseCursors.click, // Change cursor on hover
                  child: GestureDetector(
                    onTap: () {
                      _navigateToAssistantDetails(assistant.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _isHovered
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.5),
                            blurRadius: _isHovered ? 10 : 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: _isHovered
                              ? Colors.blue
                              : Colors
                                  .transparent, // Border color changes on hover
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Assistant details
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/assistant.png",
                                  width: 65,
                                  height: 65,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      assistant.assistantName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      assistant.description!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Remove icon
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Tooltip(
                              message: 'Delete Assistant',
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.trash,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _deleteAssistant(assistant.id);
                                },
                              ),
                            ),
                          ),

                          // Date time
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.clock,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(assistant.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _createNewAssistant(
      TextEditingController assistantNameController,
      TextEditingController assistantDescriptionController,
      BuildContext context) {
    final assistantName = assistantNameController.text.trim();
    final assistantDescription = assistantDescriptionController.text.trim();

    print('Assistant Name: $assistantName');
    print('Assistant Description: $assistantDescription');

    // Call the API to create a new assistant
    _knowledgeApiService.createAssistant(
        context: context, name: assistantName, desc: assistantDescription);
    // Refresh the list of assistants
    _getAssistants();
    Navigator.of(context).pop();
  }
}
