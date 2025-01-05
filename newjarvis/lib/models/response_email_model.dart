class EmailResponseModel {
  final String email;
  final int remainingUsage;

  EmailResponseModel({
    required this.email,
    required this.remainingUsage,
  });

  factory EmailResponseModel.fromJson(Map<String, dynamic> json) {
    return EmailResponseModel(
      email: json['email'] as String,
      remainingUsage: json['remainingUsage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'remainingUsage': remainingUsage,
    };
  }
}
