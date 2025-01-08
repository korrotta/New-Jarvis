class Usage {
  final String name;
  final int dailyTokens;
  final int monthlyTokens;
  final int annuallyTokens;

  Usage({
    required this.name,
    required this.dailyTokens,
    required this.monthlyTokens,
    required this.annuallyTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      name: json['name'] as String,
      dailyTokens: json['dailyTokens'] as int,
      monthlyTokens: json['monthlyTokens'] as int,
      annuallyTokens: json['annuallyTokens'] as int,
    );
  }
}
