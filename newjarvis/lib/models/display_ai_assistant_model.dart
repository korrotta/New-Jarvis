class DisplayAssistantModel {
  String name;
  String description;

  DisplayAssistantModel({
    required this.name,
    required this.description,
  });

  factory DisplayAssistantModel.fromJson(Map<String, dynamic> json) {
    return DisplayAssistantModel(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return 'DisplayAssistantModel{name: $name, description: $description}';
  }

  // Getter
  String get getName => name;
  String get getDescription => description;

  // Setter
  set setName(String name) => this.name = name;
  set setDescription(String description) => this.description = description;
}
