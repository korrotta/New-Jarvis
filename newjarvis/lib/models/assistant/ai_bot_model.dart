class AiBotModel {
  String assistantName;
  DateTime createdAt;
  String? createdBy;
  String? description;
  String id;
  String? instructions;
  String openAiAssistantId;
  String? openAiThreadIdPlay;
  DateTime? updatedAt;
  String? updatedBy;
  bool? isFavorite;

  AiBotModel({
    required this.assistantName,
    required this.createdAt,
    this.createdBy,
    this.description,
    required this.id,
    this.instructions,
    required this.openAiAssistantId,
    this.openAiThreadIdPlay,
    this.isFavorite,
    this.updatedAt,
    this.updatedBy,
  });

  AiBotModel.error(String error)
      : assistantName = error,
        createdAt = DateTime.now(),
        createdBy = '',
        description = '',
        id = '',
        instructions = '',
        openAiAssistantId = '',
        openAiThreadIdPlay = '',
        isFavorite = false,
        updatedAt = DateTime.now(),
        updatedBy = '';

  factory AiBotModel.fromJson(Map<String, dynamic> json) {
    return AiBotModel(
      assistantName: json['assistantName'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      description: json['description'],
      id: json['id'],
      instructions: json['instructions'],
      openAiAssistantId: json['openAiAssistantId'],
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
      isFavorite: json['isFavorite'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assistantName'] = assistantName;
    data['createdAt'] = createdAt.toIso8601String();
    if (createdBy != null) {
      data['createdBy'] = createdBy;
    }
    if (description != null) {
      data['description'] = description;
    }
    data['id'] = id;
    if (instructions != null) {
      data['instructions'] = instructions;
    }
    data['openAiAssistantId'] = openAiAssistantId;
    if (openAiThreadIdPlay != null) {
      data['openAiThreadIdPlay'] = openAiThreadIdPlay;
    }
    if (isFavorite != null) {
      data['isFavorite'] = isFavorite;
    }
    if (updatedAt != null) {
      data['updatedAt'] = updatedAt!.toIso8601String();
    }
    if (updatedBy != null) {
      data['updatedBy'] = updatedBy;
    }
    return data;
  }

  @override
  String toString() {
    return 'AiBotModel(assistantName: $assistantName, createdAt: $createdAt, createdBy: $createdBy, description: $description, id: $id, instructions: $instructions, openAiAssistantId: $openAiAssistantId, openAiThreadIdPlay: $openAiThreadIdPlay, updatedAt: $updatedAt, updatedBy: $updatedBy, isFavorite: $isFavorite)';
  }
}
