import 'package:newjarvis/models/ai_chat/chat_message.dart';

class ChatConversation {
  String id;
  List<ChatMessage> messages;

  ChatConversation({
    required this.id,
    required this.messages,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'],
      messages: List<ChatMessage>.from(
        json['messages'].map((x) => ChatMessage.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['messages'] = messages.map((x) => x.toJson()).toList();
    return data;
  }
}
