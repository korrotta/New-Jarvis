class ChatResponseModel {
  String id;
  String message;
  int remainingUsage;

  ChatResponseModel({
    required this.id,
    required this.message,
    required this.remainingUsage,
  });

  // Getter
  String get getId => id;
  String get getMessage => message;
  int get getRemainingUsage => remainingUsage;

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      id: json['conversationId'],
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversationId'] = id;
    data['message'] = message;
    data['remainingUsage'] = remainingUsage;
    return data;
  }

  @override
  String toString() {
    return 'ChatResponseModel{conversationId: $id, message: $message, remainingUsage: $remainingUsage}';
  }
}
