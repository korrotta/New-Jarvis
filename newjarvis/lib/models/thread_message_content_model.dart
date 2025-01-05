import 'package:newjarvis/models/message_text_content_model.dart';

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
}
