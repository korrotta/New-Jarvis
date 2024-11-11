import 'package:newjarvis/models/chat_message.dart';

class ChatConversation {
  String id;
  List<ChatMessage> messages;

  ChatConversation({
    required this.id,
    required this.messages,
  });
}
