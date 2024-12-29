import 'package:flutter/material.dart';

class AiAgent extends StatelessWidget {
  final String AiIcon;
  final String AiName;

  AiAgent({
    super.key,
    required this.AiIcon,
    required this.AiName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            AiIcon,
            fit: BoxFit.cover,
            width: 30,
            height: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            AiName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
