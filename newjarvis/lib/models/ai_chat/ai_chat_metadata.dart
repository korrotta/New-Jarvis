import 'package:newjarvis/models/ai_chat/chat_conversation.dart';

class AiChatMetadata {
  ChatConversation chatConversation;

  AiChatMetadata({
    required this.chatConversation,
  });

  factory AiChatMetadata.fromJson(Map<String, dynamic> json) {
    return AiChatMetadata(
      chatConversation: ChatConversation.fromJson(json['chat_conversation']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_conversation'] = chatConversation.toJson();
    return data;
  }

  @override
  String toString() => 'AiChatMetadata(chatConversation: $chatConversation)';
}
