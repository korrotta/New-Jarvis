import 'package:newjarvis/models/assistant/message_text_content_model.dart';

class ThreadMessageContentModel {
  final String type;
  final MessageTextContentModel text;

  ThreadMessageContentModel({
    required this.type,
    required this.text,
  });

  factory ThreadMessageContentModel.fromJson(Map<String, dynamic> json) {
    return ThreadMessageContentModel(
      type: json['type'],
      text: MessageTextContentModel.fromJson(json['text']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text.toJson(),
    };
  }

  @override
  String toString() {
    return 'ThreadMessageContentModel(type: $type, text: $text)';
  }
}
