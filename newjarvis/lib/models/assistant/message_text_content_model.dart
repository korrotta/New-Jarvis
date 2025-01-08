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

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  @override
  String toString() {
    return 'MessageTextContentModel(value: $value)';
  }
}
