import 'dart:convert';

class ConversationHistoryItemModel {
  String answer;
  int createdAt;
  List<String> files;
  String query;

  ConversationHistoryItemModel({
    required this.answer,
    required this.createdAt,
    required this.files,
    required this.query,
  });

  factory ConversationHistoryItemModel.fromMap(Map<String, dynamic> map) {
    return ConversationHistoryItemModel(
      answer: map['answer'] as String,
      createdAt: map['createdAt'] as int,
      files: List<String>.from(
          (map['files'] as List).map((item) => item as String)),
      query: map['query'] as String,
    );
  }

  factory ConversationHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ConversationHistoryItemModel(
      answer: json['answer'],
      createdAt: json['createdAt'],
      files: json['files'] != null
          ? List<String>.from(json['files'].map((x) => x))
          : [],
      query: json['query'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'answer': answer,
      'createdAt': createdAt,
      'files': files,
      'query': query,
    };
  }

  String toJson() => json.encode(toMap());
}
