import 'package:flutter/material.dart';
import 'package:newjarvis/components/prompt/prompt_detail_drawer.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/states/prompts_state.dart';
import 'package:provider/provider.dart';

// Import the PromptDetailDrawer

class PromptListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String category;
  final String author;
  final String promptContent;
  final String promptId;
  final bool isFavorite;
  final ApiService apiService = ApiService();

  PromptListItem({
    super.key,
    required this.promptId,
    required this.isFavorite,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.author,
    required this.promptContent,
  });

  void _onDelete(BuildContext context) async {
    final promptState = Provider.of<PromptState>(context, listen: false);
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Prompt'),
          content: const Text('Are you sure you want to delete this prompt?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await apiService.deletePrompt(context: context, promptId: promptId);
      // refresh list
      Provider.of<PromptState>(context, listen: false).fetchPrompts(context, isPublic: promptState.selectedCategory == 'public');
    }
  }

void _onAddToFavorites(BuildContext context) async {
    final promptState = Provider.of<PromptState>(context, listen: false);
    await apiService.addPromptToFavorites(context: context, promptId: promptId);
    // refresh list
    promptState.fetchPrompts(context, isPublic: promptState.selectedCategory == 'public');
}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          Icons.favorite_border,
          color: isFavorite ? Colors.pink : Colors.grey,
        ),
        onPressed: () => _onAddToFavorites(context),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _onDelete(context),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: () {
        // Show bottom sheet with prompt details
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: PromptDetailBottomSheet(
                title: title,
                category: category,
                author: author,
                promptContent: promptContent,
                promptId: promptId,
              ),
            );
          },
        );
      },
    );
  }
}
