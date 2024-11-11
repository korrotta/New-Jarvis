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
}
