import 'package:flutter/material.dart';
import 'package:newjarvis/states/prompts_state.dart';
import 'package:provider/provider.dart';
import 'prompt_list_item.dart';

class FavouritesPromptView extends StatefulWidget {
    const FavouritesPromptView({super.key});

    @override
    _FavouritesPromptViewState createState() => _FavouritesPromptViewState();
}

class _FavouritesPromptViewState extends State<FavouritesPromptView> {
    @override
    void initState() {
        super.initState();
        _fetchFavouritePrompts();
    }

    Future<void> _fetchFavouritePrompts() async {
        final promptState = Provider.of<PromptState>(context, listen: false);

        // Fetch favourite prompts if not already fetched
        await promptState.fetchPrompts(context, isPublic: true);
    }

    @override
    Widget build(BuildContext context) {
        return Consumer<PromptState>(
            builder: (context, promptState, _) {
                if (promptState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                }

                final prompts = promptState.favoritesPrompts;

                if (prompts.isEmpty) {
                    return const Center(child: Text("No favourite prompts available."));
                }

                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: prompts.length,
                    itemBuilder: (context, index) {
                        final prompt = prompts[index];
                        return PromptListItem(
                            isFavorite: prompt['isFavorite'] ?? true,
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

