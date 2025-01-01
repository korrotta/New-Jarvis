import 'package:flutter/material.dart';
import 'package:newjarvis/components/prompt/favourites_prompt_view.dart';
import 'package:newjarvis/components/prompt/my_prompt_view.dart';
import 'package:newjarvis/components/prompt/new_prompt_dialog.dart';
import 'package:newjarvis/components/prompt/public_prompt_view.dart';
import 'package:newjarvis/states/category_state.dart';
import 'package:newjarvis/states/prompts_state.dart';
import 'package:provider/provider.dart';

class PromptDrawerContent extends StatelessWidget {
  const PromptDrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final promptState = Provider.of<PromptState>(context, listen: false);
    final selectedCategory = Provider.of<CategoryState>(context).selectedCategory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Title and Close Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
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
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00008B),
                          Colors.lightBlueAccent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => NewPromptDialog(
                            refresh: () {
                              promptState.fetchPrompts(context, isPublic: selectedCategory == 'public');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
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
                child: Consumer<PromptState>(
                  builder: (context, promptState, _) {
                    return GestureDetector(
                      onTap: () {
                        promptState.selectedCategory = 'private';
                        promptState.notifyListeners();
                      },
                      child: TabButton(
                        text: "My Prompts",
                        isSelected: promptState.selectedCategory == 'private',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Consumer<PromptState>(
                  builder: (context, promptState, _) {
                    return GestureDetector(
                      onTap: () {
                        promptState.selectedCategory = 'public';
                        promptState.notifyListeners();
                      },
                      child: TabButton(
                        text: "Public Prompts",
                        isSelected: promptState.selectedCategory == 'public',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Consumer<PromptState>(
                  builder: (context, promptState, _) {
                    return GestureDetector(
                      onTap: () {
                        promptState.selectedCategory = 'favorites';
                        promptState.notifyListeners();
                      },
                      child: TabButton(
                        text: "My Favourites",
                        isSelected: promptState.selectedCategory == 'favorites',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Display the content based on the selected tab
        Expanded(
          child: Consumer<PromptState>(
            builder: (context, state, _) {
              return state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.selectedCategory == 'favorites'
                      ? FavouritesPromptView()
                      : state.selectedCategory == 'public'
                          ? PublicPromptsView()
                          : MyPromptsView();
            },
          ),
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

