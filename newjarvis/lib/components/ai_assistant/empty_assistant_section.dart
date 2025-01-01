import 'package:flutter/material.dart';

class EmptyAssistantSection extends StatefulWidget {
  const EmptyAssistantSection({super.key});

  @override
  State<EmptyAssistantSection> createState() => _EmptyAssistantSectionState();
}

class _EmptyAssistantSectionState extends State<EmptyAssistantSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/empty_inbox.png',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: "No Bots Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text:
                "Build a personalized AI bot with the power of LLM and plugins in minutes.",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
