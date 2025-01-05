import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';

class PromptState with ChangeNotifier {
  bool isLoading = false;
  String selectedCategory = 'public';
  List<Map<String, dynamic>> publicPrompts = [];
  List<Map<String, dynamic>> privatePrompts = [];
  List<Map<String, dynamic>> favoritesPrompts = [];

  // Toggle between Public and Private Prompts
  void togglePromptType(String promptType) {
    selectedCategory = promptType;
    notifyListeners(); // This is fine, as it's not called during build
  }

  Future<void> fetchPrompts(BuildContext context,
      {required bool isPublic, String? category}) async {
    // Delay the state update to avoid triggering it during the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading = true;
      notifyListeners(); // Notify that loading has started
    });

    try {
      if (isPublic && selectedCategory == 'public') {
        publicPrompts = await ApiService().getPrompts(
          context: context,
          category: category?.isEmpty ?? true ? 'business' : category!,
          isPublic: isPublic,
          isFavorite: selectedCategory == 'favorites',
          limit: 20,
        );
      } else if (selectedCategory == 'favorites') {
        favoritesPrompts = await ApiService().getPrompts(
          context: context,
          category: category?.isEmpty ?? true ? 'business' : category!,
          isFavorite: selectedCategory == 'favorites',
          limit: 20,
        );
      } else {
        privatePrompts = await ApiService().getPrompts(
          context: context,
          isPublic: isPublic,
          isFavorite: selectedCategory == 'favorites',
          limit: 20,
        );
      }
    } catch (e) {
      print("Error fetching prompts: $e");
    } finally {
      // Delay notifying listeners to avoid triggering during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading = false;
        notifyListeners();
      });
    }
  }
}
