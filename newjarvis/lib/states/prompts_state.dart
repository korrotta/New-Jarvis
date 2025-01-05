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
    if (selectedCategory != promptType) {
      selectedCategory = promptType;
      notifyListeners(); // Notify only when the category changes
    }
  }

  Future<void> fetchPrompts(BuildContext context,
      {required bool isPublic, String? category}) async {
    if (isLoading) return; // Prevent fetching if already in progress

    // Safely update state outside of the widget build phase
    isLoading = true;

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
      isLoading = false;
      notifyListeners(); // Notify listeners after the fetching process completes
    }
  }
}
