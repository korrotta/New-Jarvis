
import 'package:flutter/material.dart';

class CategoryState with ChangeNotifier {
  String _selectedCategory = 'business';

  List<Map<String, dynamic>> categories = [
  {'text': 'Business', 'value': 'business'},
  {'text': 'Career', 'value': 'career'},
  {'text': 'Chatbox', 'value': 'chatbox'},
  {'text': 'Education', 'value': 'education'},
  {'text': 'Marketing', 'value': 'marketing'},
  {'text': 'Productivity', 'value': 'productivity'},
  {'text': 'Seo', 'value': 'seo'},
  {'text': 'Writing', 'value': 'writing'},
  {'text': 'Other', 'value': 'other'}
];

  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
