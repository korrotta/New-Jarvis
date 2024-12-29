import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/states/chat_state.dart';
import 'package:newjarvis/states/prompts_state.dart';
import 'package:provider/provider.dart';

class PromptDetailBottomSheet extends StatefulWidget {
  final String promptId; 
  final String title;
  final String category;
  final String author;
  final String promptContent;

  const PromptDetailBottomSheet({
    required this.promptId, 
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
    _textController = TextEditingController(text: widget.promptContent);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _updatePrompt(BuildContext context) async {
    final latestValue = _textController.text.trim();
    final promptState = Provider.of<PromptState>(context, listen: false);
    final scallfoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await ApiService.instance.updatePrompt(
        context: context,
        promptId: widget.promptId,
        title: widget.title,
        content: latestValue,
        description:
            "Updated via Prompt Detail", 
        category: widget.category,
        language: "English", 
        isPublic: true, 
      );

      if (response.isNotEmpty) {
        scallfoldMessenger.showSnackBar(
          const SnackBar(content: Text('Prompt updated successfully!')),
        );
        
        promptState.fetchPrompts(context, isPublic: promptState.selectedCategory == 'public');

        print('Prompt updated: $response');
      }
    } catch (e) {
      print("Error updating prompt: $e");
      scallfoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to update the prompt.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final promptState = Provider.of<PromptState>(context, listen: false);

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
                    final latestValue = _textController.text.trim();
                    chatState.updateChatInput(latestValue);

                    // await _updatePrompt(context);

                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context)
                          .pop(); 
                    }

                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context)
                          .pop(); 
                    }
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
