class AssistantModel {
  String? id;
  String model;

  AssistantModel({
    this.id,
    required this.model,
  });

  factory AssistantModel.fromJson(Map<String, dynamic> json) {
    return AssistantModel(
      id: json['id'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['model'] = model;
    return data;
  }

  @override
  String toString() => 'AssistantModel(id: $id, model: $model)';
}
