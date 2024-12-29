import 'package:flutter/material.dart';
import 'package:newjarvis/states/prompts_state.dart';
import 'package:provider/provider.dart';
import 'prompt_list_item.dart';

class MyPromptsView extends StatefulWidget {
  const MyPromptsView({super.key});

  @override
    _MyPromptsViewState createState() => _MyPromptsViewState();
}

class _MyPromptsViewState extends State<MyPromptsView> {
  @override
    void initState() {
      super.initState();
      _fetchPrivatePrompts();
    }

  Future<void> _fetchPrivatePrompts() async {
    final promptState = Provider.of<PromptState>(context, listen: false);

    // Fetch private prompts if not already fetched
    await promptState.fetchPrompts(context, isPublic: false);
  }

  @override
    Widget build(BuildContext context) {
      return Consumer<PromptState>(
          builder: (context, promptState, _) {
          if (promptState.isLoading) {
          return const Center(child: CircularProgressIndicator());
          }

          final prompts = promptState.privatePrompts;

          if (prompts.isEmpty) {
          return const Center(child: Text("No prompts available."));
          }

          return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: prompts.length,
              itemBuilder: (context, index) {
              final prompt = prompts[index];
              return PromptListItem(
                isFavorite: prompt['isFavorite'] ?? false,
                  promptId: prompt['_id'] ?? '0',
                  title: prompt['title'] ?? 'No Title',
                  subtitle: prompt['description'] ?? '',
                  category: prompt['category'] ?? 'Other',
                  author: prompt['userName'] ?? 'Anonymous',
                  promptContent: prompt['content'] ?? 'No Content',
                  );
              },
              );
          },
        );
    }
}
