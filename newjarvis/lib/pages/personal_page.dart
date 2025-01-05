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
import 'package:newjarvis/pages/assistant_page.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.smart_toy_rounded,
                    size: 22,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Assistant",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 20,
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentUser?.username ?? "Unknown",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _currentUser?.email ?? "Unknown",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Create Assistant Section
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          runAlignment: WrapAlignment.start,
          children: [
            SizedBox(
              width: 200,
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
            CustomDropdownmenu(
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
          ],
        ),

        const SizedBox(height: 5),

        // Create button
        // ElevatedButton.icon(
        //   onPressed: () {
        //     // Show the create bot dialog
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         // Dialog include (title, assistant name*, assistant description, create button, cancel button)
        //         return _showCreateDialog(_assistantNameController,
        //             _assistantDescriptionController, context);
        //       },
        //     );
        //   },
        //   icon: const Icon(Icons.add, color: Colors.white),
        //   label: const Text(
        //     "Create bot",
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     minimumSize: const Size(120, 55),
        //     backgroundColor: Colors.blueAccent,
        //     side: BorderSide(
        //       color: Theme.of(context).colorScheme.inversePrimary,
        //     ),
        //   ),
        // ),

        const SizedBox(height: 10),

        // List of assistants
        Expanded(
          child: _buildAssistantList(),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blueAccent,
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
              child: Icon(
                CupertinoIcons.add,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
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
              maxLength: 1,
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
              maxLines: 6,
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
          onPressed: () {
            _validateFields(assistantNameController, context);
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
    AiBotModel selectedAssistant =
        _assistants.firstWhere((element) => element.id == assistantId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AssistantPage(selectedAssistant: selectedAssistant),
      ),
    );
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
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text("Create Bot Now",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
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
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).size.width ~/ 250).toInt(),
              childAspectRatio: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final assistant = items[index];
              return GestureDetector(
                onTap: () {
                  _navigateToAssistantDetails(assistant.id);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                              width: 45,
                              height: 45,
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
                                Text(
                                  assistant.description ?? "",
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _validateFields(
      TextEditingController assistantNameController, BuildContext context) {
    final assistantName = assistantNameController.text.trim();

    if (assistantName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assistant name cannot be empty')),
      );
      return;
    }
  }

  Future<void> _createNewAssistant(
      TextEditingController assistantNameController,
      TextEditingController assistantDescriptionController,
      BuildContext context) async {
    final assistantName = assistantNameController.text.trim();
    final assistantDescription = assistantDescriptionController.text.trim();

    print('Assistant Name: $assistantName');
    print('Assistant Description: $assistantDescription');

    // Call the API to create a new assistant
    await _knowledgeApiService.createAssistant(
        context: context, name: assistantName, desc: assistantDescription);

    _getAssistants();

    // Close the dialog
    Navigator.of(context).pop();
  }
}
