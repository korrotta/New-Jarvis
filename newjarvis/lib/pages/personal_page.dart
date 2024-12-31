import 'package:flutter/material.dart';
import 'package:newjarvis/components/custom_textfield.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/route_controller.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/models/basic_user_model.dart';
import 'package:newjarvis/providers/auth_provider.dart';
import 'package:newjarvis/services/knowledge_api_service.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  List<dynamic> assistants = []; // Fetched assistants
  final KnowledgeApiService _knowledgeApiService = KnowledgeApiService();
  int selectedIndex = 1;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  bool isDrawerVisible = false;
  double dragOffset = 200.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loginKnowledgeApi();
    _getAssistants();
  }

  Future<void> _getAssistants() async {
    try {
      final fetchedAssistants =
          await _knowledgeApiService.getAssistants(context: context);
      setState(() {
        assistants = fetchedAssistants['data'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load assistants: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isSidebarVisible = false;
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(top: 20),
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the layout adjusts for the keyboard
        body: authProvider.currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  AnimatedContainer(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(
                      right: isSidebarVisible ? (isExpanded ? 180 : 98) : 0,
                    ),
                    width: double.infinity,
                    child: _buildPageContent(context),
                  ),

                  // Sidebar
                  if (isSidebarVisible)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: SideBar(
                        isExpanded: isExpanded,
                        selectedIndex: selectedIndex,
                        onItemSelected: _onItemTapped,
                        onExpandToggle: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        onClose: () {
                          setState(() {
                            isSidebarVisible = false;
                          });
                        },
                      ),
                    ),

                  // Nửa hình tròn khi sidebar bị ẩn (Floating Button)
                  if (!isSidebarVisible)
                    FloatingButton(
                      dragOffset: dragOffset,
                      onDragUpdate: (delta) {
                        setState(
                          () {
                            dragOffset += delta;
                            if (dragOffset < 0) dragOffset = 0;
                            if (dragOffset >
                                MediaQuery.of(context).size.height - 100) {
                              dragOffset =
                                  MediaQuery.of(context).size.height - 100;
                            }
                          },
                        );
                      },
                      onTap: () {
                        setState(
                          () {
                            isSidebarVisible = true;
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
    final BasicUserModel? currentUser =
        Provider.of<AuthProvider>(context).currentUser;

    TextEditingController assistantNameController = TextEditingController();
    TextEditingController assistantDescriptionController =
        TextEditingController();

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
                  Icons.person,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                Text(
                  "Personal",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
            // Display current user name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: currentUser?.username != null
                      ? Text(currentUser!.username![0].toUpperCase())
                      : const Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser?.username ?? "Unknown",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentUser?.email ?? "Unknown",
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dropdown and Search Bar
            Row(
              children: [
                DropdownButton<String>(
                  value: "All",
                  items: const [
                    DropdownMenuItem(
                      value: "All",
                      child: Text("All"),
                    ),
                    DropdownMenuItem(
                      value: "Favorites",
                      child: Text("Favorites"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(
                    width: 16), // Add space between dropdown and search bar
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Spacer to push the Create button to the far right
            ElevatedButton.icon(
              onPressed: () {
                // Show the create bot dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    // Dialog include (title, assistant name*, assistant description, create button, cancel button)
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
                            validator: (p0) =>
                                p0!.isEmpty ? "Name is required" : null,
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
                            final assistantName =
                                assistantNameController.text.trim();
                            final assistantDescription =
                                assistantDescriptionController.text.trim();

                            print('Assistant Name: $assistantName');
                            print(
                                'Assistant Description: $assistantDescription');

                            _knowledgeApiService.createAssistant(
                                assistantName, assistantDescription);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Create",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Create bot"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 48),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // List of assistants
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assistants.length,
            itemBuilder: (context, index) {
              final assistant = assistants[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.smart_toy, color: Colors.blue),
                  ),
                  title: Text(assistant['assistantName'] ?? 'Unknown Name'),
                  subtitle: Text(
                      assistant['description'] ?? 'No description available'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          assistant['isFavorite'] == true
                              ? Icons.star
                              : Icons.star_border,
                          color: assistant['isFavorite'] == true
                              ? Colors.yellow
                              : null,
                        ),
                        onPressed: () {
                          // Add your logic to toggle favorite status
                          print(
                              'Favorite toggled for: ${assistant['assistantName']}');
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          // Add your logic to delete the assistant
                          print('Deleted: ${assistant['assistantName']}');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              _knowledgeApiService.getAssistants(context: context);
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Get Assistants"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }
}
