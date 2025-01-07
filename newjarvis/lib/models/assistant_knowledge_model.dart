class AssistantKnowledgeModel {
  String userId;
  DateTime createdAt;
  String? createdBy;
  String description;
  String knowledgeName;
  DateTime? updatedAt;
  String? updatedBy;
  String knowledgeId;

  AssistantKnowledgeModel({
    required this.userId,
    required this.createdAt,
    this.createdBy,
    required this.description,
    required this.knowledgeName,
    required this.knowledgeId,
    this.updatedAt,
    this.updatedBy,
  });

  factory AssistantKnowledgeModel.fromJson(Map<String, dynamic> json) {
    return AssistantKnowledgeModel(
      knowledgeId: json['knowledgeId'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      description: json['description'],
      knowledgeName: json['knowledgeName'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'knowledgeId': knowledgeId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'description': description,
      'knowledgeName': knowledgeName,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }

  @override
  String toString() {
    return 'AssistantKnowledgeModel(userId: $userId, createdAt: $createdAt, createdBy: $createdBy, description: $description, knowledgeName: $knowledgeName, updatedAt: $updatedAt, updatedBy: $updatedBy, knowledgeId: $knowledgeId)';
  }
}
