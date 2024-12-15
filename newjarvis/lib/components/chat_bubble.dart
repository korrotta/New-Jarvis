import 'package:flutter/material.dart';

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
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isQuery
            ? (isDarkTheme ? Colors.blue.shade600 : Colors.blue.shade500)
            : (isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: RichText(
        text: _parseMessage(message, isQuery, isDarkTheme),
      ),
    );
  }

  TextSpan _parseMessage(String message, bool isQuery, bool isDarkTheme) {
    final spans = <TextSpan>[];
    final boldRegex = RegExp(r'\*\*(.*?)\*\*'); // Match **bold**

    int start = 0;
    for (final match in boldRegex.allMatches(message)) {
      // Add text before the bold part
      if (match.start > start) {
        spans.add(TextSpan(
          text: message.substring(start, match.start),
          style: TextStyle(
            color: isQuery
                ? Colors.white
                : (isDarkTheme ? Colors.white : Colors.black),
          ),
        ));
      }

      // Add the bold text
      spans.add(TextSpan(
        text: match.group(1), // The content inside ** **
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isQuery
              ? Colors.white
              : (isDarkTheme ? Colors.white : Colors.black),
        ),
      ));

      start = match.end;
    }

    // Add remaining text
    if (start < message.length) {
      spans.add(TextSpan(
        text: message.substring(start),
        style: TextStyle(
          color: isQuery
              ? Colors.white
              : (isDarkTheme ? Colors.white : Colors.black),
        ),
      ));
    }

    return TextSpan(children: spans);
  }
}
