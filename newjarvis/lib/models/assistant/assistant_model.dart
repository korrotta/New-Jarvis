class AssistantModel {
  String? id;
  final String model = 'dify';

  AssistantModel({
    this.id,
  });

  factory AssistantModel.fromJson(Map<String, dynamic> json) {
    return AssistantModel(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  @override
  String toString() => 'AssistantModel(id: $id, model: $model)';
}
