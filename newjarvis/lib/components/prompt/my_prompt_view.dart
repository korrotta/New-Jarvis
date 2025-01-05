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
  late Future<void> _fetchPrivatePromptsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPrivatePromptsFuture = _fetchPrivatePrompts();
  }

  Future<void> _fetchPrivatePrompts() async {
    final promptState = Provider.of<PromptState>(context, listen: false);

    // Fetch private prompts
    await promptState.fetchPrompts(context, isPublic: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchPrivatePromptsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error fetching prompts: ${snapshot.error}"),
          );
        }

        // Access the prompts from PromptState
        final promptState = Provider.of<PromptState>(context);
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
