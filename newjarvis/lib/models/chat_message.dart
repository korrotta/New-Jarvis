import 'package:newjarvis/models/assistant_model.dart';

class ChatMessage {
  AssistantModel assistant;
  String content;
  List<String> files;
  String role;

  ChatMessage({
    required this.assistant,
    required this.content,
    required this.files,
    required this.role,
  });
}
