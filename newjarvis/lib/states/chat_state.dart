import 'package:flutter/material.dart';
import 'dart:async';

class ChatState with ChangeNotifier {
  String _chatInput = '';
  bool _isPromptMenuVisible = false;
  String _promptSearchQuery = '';
  Timer? _debounce;

  String get chatInput => _chatInput;
  bool get isPromptMenuVisible => _isPromptMenuVisible;
  String get promptSearchQuery => _promptSearchQuery;

  void updateChatInput(String newInput) {
    _chatInput = newInput;
    _evaluatePromptMenuVisibility();
    notifyListeners();
  }

  void clearChatInput() {
    _chatInput = '';
    notifyListeners();
  }

  void _evaluatePromptMenuVisibility() {
    if (_chatInput.startsWith('/')) {
      _debouncedUpdatePromptSearchQuery(_chatInput.substring(1));
      _isPromptMenuVisible = true;
    } else {
      _isPromptMenuVisible = false;
      _promptSearchQuery = '';
      notifyListeners();
    }
  }

  void _debouncedUpdatePromptSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _promptSearchQuery = query;
      notifyListeners();
    });
  }

  void updatePromptSearchQuery(String query) {
    _promptSearchQuery = query;
    notifyListeners();
  }
}

