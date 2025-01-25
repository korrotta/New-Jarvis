import 'package:flutter/material.dart';

class AiAgent extends StatelessWidget {
  final String aiIcon;
  final String aiName;

  const AiAgent({
    super.key,
    required this.aiIcon,
    required this.aiName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 3),
        ClipOval(
          child: Container(
            color: Colors.blue.shade800,
            child: Image.asset(
              aiIcon,
              fit: BoxFit.cover,
              width: 20,
              height: 21,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          aiName,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
