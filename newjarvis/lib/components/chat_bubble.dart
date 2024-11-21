import 'package:flutter/material.dart';
import 'package:newjarvis/services/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isQuery;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isQuery,
  });

  @override
  Widget build(BuildContext context) {
    // Light theme and Dark theme
    bool isDarkTheme = false;

    return Container(
      decoration: BoxDecoration(
        color: isQuery
            ? (isDarkTheme ? Colors.blue.shade600 : Colors.blue.shade500)
            : (isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Text(
        message,
        style: TextStyle(
          color: isQuery
              ? Colors.white
              : (isDarkTheme ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
