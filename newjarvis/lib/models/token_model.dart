class TokenModel {
  String token;
  String refreshToken;
  int availableTokens;
  int totalTokens;
  bool unlimited;
  dynamic date;

  TokenModel({
    required this.token,
    required this.refreshToken,
    required this.availableTokens,
    required this.totalTokens,
    required this.unlimited,
    this.date,
  });
}
