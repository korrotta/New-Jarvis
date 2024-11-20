class ConversationItemModel {
  String title;
  String id;
  int createdAt;

  ConversationItemModel({
    required this.title,
    required this.id,
    required this.createdAt,
  });

  factory ConversationItemModel.fromMap(Map<String, dynamic> map) {
    return ConversationItemModel(
      title: map['title'] as String,
      id: map['id'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  factory ConversationItemModel.fromJson(Map<String, dynamic> json) {
    return ConversationItemModel(
      title: json['title'],
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'id': id,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() =>
      'ConversationItemModel(title: $title, id: $id, createdAt: $createdAt)';
}
