import 'package:flutter/material.dart';
import 'package:newjarvis/components/my_prompt_view.dart';
import 'package:newjarvis/components/new_prompt_dialog.dart';
import 'package:newjarvis/components/public_prompt_view.dart';
import 'package:newjarvis/services/api_service.dart';

class PromptDrawerContent extends StatefulWidget {
  @override
  _PromptDrawerContentState createState() => _PromptDrawerContentState();
}

class _PromptDrawerContentState extends State<PromptDrawerContent> {
  bool isPublicPromptSelected = true; // Track the selected view
  List<Map<String, dynamic>> publicPrompts = []; // List to store public prompts
  List<Map<String, dynamic>> privatePrompts =
      []; // List to store private prompts
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchPrompts(); // Fetch prompts on initialization
  }

  Future<void> fetchPrompts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch public prompts
      final fetchedPublicPrompts = await ApiService().getPrompts(
        context: context,
        isPublic: true,
        isFavorite: false,
        limit: 20,
      );

      print('fetchedPublicPrompts: $fetchedPublicPrompts');

      // Fetch private prompts
      final fetchedPrivatePrompts = await ApiService().getPrompts(
        context: context,
        isPublic: false,
        isFavorite: false,
        limit: 20,
      );

      setState(() {
        publicPrompts = fetchedPublicPrompts;
        privatePrompts = fetchedPrivatePrompts;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching prompts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Title and Close Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Prompt",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                            colors: [
                              Colors.blue[900]!,
                              Colors.lightBlueAccent,
                            ], // Gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove default padding
                      constraints: BoxConstraints(), // Shrink to fit
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () => {
                        showDialog(
                          context: context,
                          builder: (context) => NewPromptDialog(),
                        )
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPublicPromptSelected = false; // Switch to My Prompts
                    });
                  },
                  child: TabButton(
                    text: "My Prompts",
                    isSelected: !isPublicPromptSelected,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPublicPromptSelected = true; // Switch to Public Prompts
                    });
                  },
                  child: TabButton(
                    text: "Public Prompts",
                    isSelected: isPublicPromptSelected,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Display the content based on the selected tab
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Show loader
              : isPublicPromptSelected
                  ? PublicPromptsView(
                      prompts: publicPrompts) // Public Prompts Content
                  : MyPromptsView(
                      prompts: privatePrompts), // My Prompts Content
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  const TabButton({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
