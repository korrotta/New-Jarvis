import 'package:flutter/material.dart';
import 'package:newjarvis/components/prompt_list_item.dart';
import 'package:provider/provider.dart';
import '../states/category_state.dart';
import '../states/prompts_state.dart';

class PublicPromptsView extends StatefulWidget {
  const PublicPromptsView({super.key});

  @override
  _PublicPromptsViewState createState() => _PublicPromptsViewState();
}

class _PublicPromptsViewState extends State<PublicPromptsView> {
  @override
  void initState() {
    super.initState();
    _fetchInitialPrompts();
  }

  Future<void> _fetchInitialPrompts() async {
    final categoryState = Provider.of<CategoryState>(context, listen: false);
    final promptState = Provider.of<PromptState>(context, listen: false);

    // Initial fetch of prompts for the selected category
    await promptState.fetchPublicPrompts(context, categoryState.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<CategoryState>(context);
    final promptState = Provider.of<PromptState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categories (Chips)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categoryState.categories.map((category) {
                final isSelected = categoryState.selectedCategory == category['value'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Update selected category and fetch prompts
                      categoryState.selectCategory(category['value']);
                      promptState.fetchPublicPrompts(context, categoryState.selectedCategory);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: CategoryChip(
                        text: category['text'],
                        isSelected: isSelected,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Prompts List
        Expanded(
          child: Consumer<PromptState>(
            builder: (context, state, _) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final prompts = state.publicPrompts;

              if (prompts.isEmpty) {
                return const Center(child: Text("No prompts available."));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: prompts.length,
                itemBuilder: (context, index) {
                  final prompt = prompts[index];
                  return GestureDetector(
                    onTap: () {
                      // Handle list item click
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: PromptListItem(
                        promptId: prompt['_id'] ?? '0',
                        title: prompt['title'] ?? 'No Title',
                        subtitle: prompt['description'] ?? '',
                        category: prompt['category'] ?? 'Other',
                        author: prompt['userName'] ?? 'Anonymous',
                        promptContent: prompt['content'] ?? 'No Content',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CategoryChip({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}

