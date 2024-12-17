import 'package:flutter/material.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/route_controller.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/providers/auth_provider.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/services/knowledge_api_service.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final KnowledgeApiService _knowledgeApiService = KnowledgeApiService();
  int selectedIndex = 1;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  bool isDrawerVisible = false;
  double dragOffset = 200.0;

  @override
  void initState() {
    super.initState();
    _loginKnowledgeApi();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Personal",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            CircleAvatar(
              child: Text('T'),
              backgroundColor: Colors.blue.shade100,
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                "Bots",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Knowledge",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.smart_toy, color: Colors.blue),
                  ),
                  title: Text("tent"),
                  subtitle: Text("Software engineer"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_border),
                      SizedBox(width: 16),
                      Icon(Icons.delete_outline),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text("Create bot"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48), // Full-width button
            ),
          ),
        ),
      ],
    );
  }
}
