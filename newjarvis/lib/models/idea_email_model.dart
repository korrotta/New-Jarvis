class EmailIdeaResponseModel {
  final List<String> ideas;

  EmailIdeaResponseModel({
    required this.ideas,
  });

  factory EmailIdeaResponseModel.fromJson(Map<String, dynamic> json) {
    return EmailIdeaResponseModel(
      ideas: List<String>.from(json['ideas'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ideas': ideas,
    };
  }
}
