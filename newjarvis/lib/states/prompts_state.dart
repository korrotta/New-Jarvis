import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';

class PromptState with ChangeNotifier {
  bool isLoading = false;
  bool isPublicPromptSelected = true; // Track the selected tab/view
  List<Map<String, dynamic>> publicPrompts = [];
  List<Map<String, dynamic>> privatePrompts = [];

  // Toggle between Public and Private Prompts
  void togglePromptType(bool isPublic) {
    isPublicPromptSelected = isPublic;
    notifyListeners(); // Notify listeners of the change
  }

  Future<void> fetchPublicPrompts(BuildContext context,[String? category]) async {
    isLoading = true;
    notifyListeners(); // Notify listeners of state change
  
    try {
      // Fetch public prompts
      publicPrompts = await ApiService().getPrompts(
        context: context,
        category: category == '' ? 'business' : category,
        isPublic: true,
        isFavorite: false,
        limit: 20,
      );
    } catch (e) {
      print("Error fetching public prompts: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners of state change
    }
  }
  
  Future<void> fetchPrivatePrompts(BuildContext context, [String? category]) async {
    isLoading = true;
    notifyListeners(); // Notify listeners of state change
  
    try {
      // Fetch private prompts
      privatePrompts = await ApiService().getPrompts(
        context: context,
        isPublic: false,
        isFavorite: false,
        limit: 20,
      );
    } catch (e) {
      print("Error fetching private prompts: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners of state change
    }
  }
}
