import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/states/chat_state.dart';
import 'package:newjarvis/states/prompts_state.dart';
import 'package:provider/provider.dart';

class PromptDetailBottomSheet extends StatefulWidget {
  final String promptId; // Add prompt ID
  final String title;
  final String category;
  final String author;
  final String promptContent;

  const PromptDetailBottomSheet({
    required this.promptId, // Include prompt ID as a parameter
    required this.title,
    required this.category,
    required this.author,
    required this.promptContent,
  });

  @override
  State<PromptDetailBottomSheet> createState() =>
      _PromptDetailBottomSheetState();
}

class _PromptDetailBottomSheetState extends State<PromptDetailBottomSheet> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the promptContent
    _textController = TextEditingController(text: widget.promptContent);
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    _textController.dispose();
    super.dispose();
  }

  Future<void> _updatePrompt(BuildContext context) async {
    final latestValue = _textController.text.trim();

    try {
      final response = await ApiService.instance.updatePrompt(
        context: context,
        promptId: widget.promptId, // Pass the prompt ID
        title: widget.title,
        content: latestValue,
        description: "Updated via Prompt Detail", // Adjust description as needed
        category: widget.category,
        language: "English", // Assume language is English, adjust as needed
        isPublic: true, // Adjust visibility as needed
      );

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompt updated successfully!')),
        );
        // refresh the prompt list
        Provider.of<PromptState>(context, listen: false).fetchPrompts(context);
        print('Prompt updated: $response');
      }
    } catch (e) {
      print("Error updating prompt: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update the prompt.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Category and Author
            Text(
              "${widget.category} · ${widget.author}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Prompt TextField
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: "Write your prompt here...",
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save and Send Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    // Call updatePrompt when Save is clicked
                    await _updatePrompt(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Get the latest value from the controller
                    final latestValue = _textController.text.trim();

                    // Update the chat input state
                    Provider.of<ChatState>(context, listen: false)
                        .updateChatInput(latestValue);

                    // Call updatePrompt when Send is clicked
                    await _updatePrompt(context);

                    // Close the bottom sheet
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
