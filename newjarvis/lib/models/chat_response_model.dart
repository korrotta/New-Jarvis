class ChatResponseModel {
  String? id;
  String? message;
  int? remainingUsage;

  ChatResponseModel({
    required this.id,
    required this.message,
    required this.remainingUsage,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      id: json['id'],
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['remainingUsage'] = remainingUsage;
    return data;
  }

  @override
  String toString() {
    return 'ChatResponseModel{id: $id, message: $message, remainingUsage: $remainingUsage}';
  }
}
