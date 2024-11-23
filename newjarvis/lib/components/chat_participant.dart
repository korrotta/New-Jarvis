import 'package:flutter/material.dart';

class ChatParticipant {
  final String name;
  final Icon icon;

  ChatParticipant({required this.name, required this.icon});
}

final userParticipant = ChatParticipant(
  name: 'You',
  icon: const Icon(
    Icons.person_outline_outlined,
    color: Colors.black,
    size: 14,
  ),
);

final botParticipant = ChatParticipant(
  name: 'Assistant',
  icon: const Icon(
    Icons.smart_toy_rounded,
    color: Colors.blue,
    size: 14,
  ),
);
