class SubscriptionModel {
  final String name;

  SubscriptionModel({
    required this.name,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      name: json['name'] as String,
    );
  }
}
