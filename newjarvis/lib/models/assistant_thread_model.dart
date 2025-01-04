class AssistantThreadModel {
  String assistantId;
  DateTime createdAt;
  String? createdBy;
  String id;
  String openAiThreadId;
  String threadName;
  DateTime? updatedAt;
  String? updatedBy;

  AssistantThreadModel({
    required this.assistantId,
    required this.createdAt,
    this.createdBy,
    required this.id,
    required this.openAiThreadId,
    required this.threadName,
    this.updatedAt,
    this.updatedBy,
  });

  factory AssistantThreadModel.fromJson(Map<String, dynamic> json) {
    return AssistantThreadModel(
      assistantId: json['assistantId'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      id: json['id'],
      openAiThreadId: json['openAiThreadId'],
      threadName: json['threadName'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedBy: json['updatedBy'],
    );
  }

  @override
  String toString() {
    return 'AssistantThreadModel(assistantId: $assistantId, createdAt: $createdAt, createdBy: $createdBy, id: $id, openAiThreadId: $openAiThreadId, threadName: $threadName, updatedAt: $updatedAt, updatedBy: $updatedBy)';
  }
}
