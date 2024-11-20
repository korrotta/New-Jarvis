import 'package:newjarvis/models/ai_chat_metadata.dart';
import 'package:newjarvis/models/assistant_model.dart';

class AiChatModel {
  AssistantModel? assistant;
  String content;
  List<String>? files;
  AiChatMetadata? metadata;

  AiChatModel({
    this.assistant,
    required this.content,
    this.files,
    this.metadata,
  });

  factory AiChatModel.fromJson(Map<String, dynamic> json) {
    return AiChatModel(
      assistant: json['assistant'] != null
          ? AssistantModel.fromJson(json['assistant'])
          : null,
      content: json['content'],
      files: json['files'] != null
          ? List<String>.from(json['files'].map((x) => x))
          : null,
      metadata: json['metadata'] != null
          ? AiChatMetadata.fromJson(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assistant != null) {
      data['assistant'] = assistant!.toJson();
    }
    data['content'] = content;
    if (files != null) {
      data['files'] = files;
    }
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'AiChatModel(assistant: $assistant, content: $content, files: $files, metadata: $metadata)';
  }
}
