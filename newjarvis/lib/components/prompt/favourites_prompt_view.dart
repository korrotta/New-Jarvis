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
    late Future<void> _fetchFavouritePromptsFuture;

    @override
    void initState() {
        super.initState();
        _fetchFavouritePromptsFuture = _fetchFavouritePrompts();
    }

    Future<void> _fetchFavouritePrompts() async {
        final promptState = Provider.of<PromptState>(context, listen: false);

        // Fetch favourite prompts
        await promptState.fetchPrompts(context, isPublic: true, category: 'favorites');
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<void>(
            future: _fetchFavouritePromptsFuture,
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                    return Center(
                        child: Text("Error fetching favourite prompts: ${snapshot.error}"),
                    );
                }

                // Access the prompts from PromptState
                final promptState = Provider.of<PromptState>(context);
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
