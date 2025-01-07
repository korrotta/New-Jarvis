import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatParticipant {
  final String name;
  final Icon icon;

  ChatParticipant({required this.name, required this.icon});
}

final userParticipant = ChatParticipant(
  name: 'You',
  icon: const Icon(
    CupertinoIcons.person_alt,
    color: Colors.black,
    size: 18,
  ),
);

final botParticipant = ChatParticipant(
  name: 'Assistant',
  icon: const Icon(
    Icons.smart_toy_rounded,
    color: Colors.blueAccent,
    size: 18,
  ),
);
