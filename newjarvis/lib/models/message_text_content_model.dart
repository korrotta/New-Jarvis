class MessageTextContentModel {
  final String value;

  MessageTextContentModel({
    required this.value,
  });

  factory MessageTextContentModel.fromJson(Map<String, dynamic> json) {
    return MessageTextContentModel(
      value: json['value'],
    );
  }
}
