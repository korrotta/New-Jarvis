import 'package:newjarvis/models/assistant/thread_message_content_model.dart';

class AssistantThreadMessageModel {
  List<ThreadMessageContentModel> content;
  int createdAt;
  String role;

  AssistantThreadMessageModel({
    required this.content,
    required this.createdAt,
    required this.role,
  });

  factory AssistantThreadMessageModel.fromJson(Map<String, dynamic> json) {
    return AssistantThreadMessageModel(
      content: List<ThreadMessageContentModel>.from(
          json['content'].map((x) => ThreadMessageContentModel.fromJson(x))),
      createdAt: json['createdAt'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'AssistantThreadMessageModel(content: $content, createdAt: $createdAt, role: $role)';
  }
}
