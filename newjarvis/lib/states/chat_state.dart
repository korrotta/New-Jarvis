import 'package:flutter/material.dart';

class ChatState with ChangeNotifier {
  String _chatInput = '';

  String get chatInput => _chatInput;

  void updateChatInput(String newInput) {
    _chatInput = newInput;
    notifyListeners(); // Notify listeners to rebuild
  }

  void clearChatInput() {
    _chatInput = '';
    notifyListeners();
  }
}
