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

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      assistant: AssistantModel.fromJson(json['assistant']),
      content: json['content'],
      files: List<String>.from(json['files'].map((x) => x)),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assistant'] = assistant.toJson();
    data['content'] = content;
    data['files'] = files;
    data['role'] = role;
    return data;
  }

  @override
  String toString() {
    return 'ChatMessage(assistant: $assistant, content: $content, files: $files, role: $role)';
  }
}
