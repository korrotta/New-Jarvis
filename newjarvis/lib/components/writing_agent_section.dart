import 'package:flutter/material.dart';

class WritingAgentSection extends StatelessWidget {
  const WritingAgentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Background image
          Image.asset(
            'assets/images/email_marketing.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: 84,
          ),
          // Text
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              'Writing Agent',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
