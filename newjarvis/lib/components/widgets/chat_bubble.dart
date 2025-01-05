import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
      child: message.isEmpty
          ? const TypingIndicator()
          : MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: isQuery
                      ? Colors.white
                      : (isDarkTheme ? Colors.white : Colors.black),
                ),
                code: TextStyle(
                  fontFamily: 'monospace',
                  backgroundColor:
                      isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
                strong: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isQuery
                      ? Colors.white
                      : (isDarkTheme ? Colors.white : Colors.black),
                ),
                em: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: isQuery
                      ? Colors.white
                      : (isDarkTheme ? Colors.white : Colors.black),
                ),
                blockquote: TextStyle(
                  color: isQuery
                      ? Colors.white70
                      : (isDarkTheme ? Colors.white70 : Colors.black54),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        int dotCount = (3 * _animation.value).floor() + 1;
        String dots = List.filled(dotCount, '.').join();
        return Text(
          dots.padRight(3, ' '), // Always keep 3 placeholders
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        );
      },
    );
  }
}
