class TokenUsageModel {
  String remainingTokens;
  String totalTokens;
  bool unlimited;
  String date;

  TokenUsageModel({
    required this.remainingTokens,
    required this.totalTokens,
    required this.unlimited,
    required this.date,
  });

  String getRemainingTokens() {
    return remainingTokens;
  }

  String getTotalTokens() {
    return totalTokens;
  }

  bool getUnlimited() {
    return unlimited;
  }

  String getDate() {
    return date;
  }

  factory TokenUsageModel.fromJson(Map<String, dynamic> json) {
    return TokenUsageModel(
      remainingTokens: json['remaining_tokens'],
      totalTokens: json['total_tokens'],
      unlimited: json['unlimited'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remaining_tokens': remainingTokens,
      'total_tokens': totalTokens,
      'unlimited': unlimited,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'TokenUsageModel(remainingTokens: $remainingTokens, totalTokens: $totalTokens, unlimited: $unlimited, date: $date)';
  }
}
